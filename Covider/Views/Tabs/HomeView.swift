//
//  HomeView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var searchBar: SearchBar                = SearchBar()
    @State private var showingSetupForm: Bool                       = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Duty.startDate,
                             ascending: true)
        ],
        animation: .default
    ) private var duties: FetchedResults<Duty>
    
    var body: some View {
        ZStack {
            /*  MARK: iOS 15.0 BETA 8 (19A5340a) - Toolbar Bug
             *  ---------------------------------------------
             *  After switching from WelcomeView() - by clicking the button - to this view, by using
             *  .fullScreenCover(item: Binding<Identifiable?>, content: (Identifiable) -> View),
             *  at the first start of the app, the toolbar does not display.
             *  On the iOS 14.5 and Xcode 12.5.1 simulator (12E507), everything works correctly.
             *
             *  Placing the .navigationViewStyle(StackNavigationViewStyle()) in the middle of NavigationView,
             *  right after .toolbar(content: createToolbar), turned out to be a solution.
             *  Unfortunately, after starting DutySetupAlert(), the toolbar moved up (y offset).
             *  After moving it after NavigationView, it only worked below iOS 15.0.
             *
             *  On iPad 15.0 it works as I described above. Unfortunately, a style modifier after
             *  the NavigationView is needed for correct work on the iPad.
             *
             *  This and the fact that iOS 15.0 has not been published resulted in inserting
             *  the style after the NavigationView.
             *
             *  Moreover, this is the correct use of this modifier.
             */
            NavigationView {
                listView
                    .navigationBarTitle(LocalizedStrings.duties)
                    .toolbar(content: createToolbar)
                    .add(searchBar)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .blur(radius: showingSetupForm ? 3 : 0)
            .overlay(showingSetupForm ? overlay : nil)
            
            // Setup Alert
            DutySetupAlert(isVisible: $showingSetupForm)
                .offset(y: showingSetupForm ? 0 : UIScreen.main.bounds.height)
                .ignoresSafeArea()
        }
    }
}

// MARK: - Methods
private extension HomeView {
    /// This method filters an array with duties using the search text, entered in Search Bar.
    /// - Parameter duty: Fetched object, stores data about the duty.
    /// - Returns: A logical value indicates whether a given duty contains the given text.
    ///            If so, it is displayed in HomeView.
    func filterDutiesArray(_ duty: Duty) -> Bool {
        let dateFormatter = DateFormatter()
        let startDate = dateFormatter.string(from: duty.startDate)
        let endDate = dateFormatter.string(from: duty.endDate)
        
        return searchBar.text.isEmpty ||
               duty.title.contains(searchBar.text) ||
               duty.description.contains(searchBar.text) ||
               duty.guardName.contains(searchBar.text) ||
               startDate.contains(searchBar.text) ||
               endDate.contains(searchBar.text)
    }
    
    /// This method removes selected duty from the context.
    /// - Parameter offsets: A set of indexes representing elements in the duties array.
    func removeDuty(at offsets: IndexSet) {
        for index in offsets {
            let duty = duties[index]
            viewContext.delete(duty)
            PersistenceController.shared.saveContext()
        }
    }
}

// MARK: - Views
private extension HomeView {
    // I use the overlay variable because the opacity change
    // using the ternary operator in the .overlay modifier, for some reason,
    // disabled the functionality of the application in dark mode
    // (the ToolbarItems did not work).
    var overlay: some View {
        Color.primary
            .opacity(0.4)
            .ignoresSafeArea()
    }
    
    // List or description that duties array does not contain data.
    @ViewBuilder var listView: some View {
        if duties.isEmpty {
            // Text telling that the list is empty
            VStack {
                Spacer()
                Text(LocalizedStrings.emptyList)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .opacity(0.2)
                    .padding()
                Spacer()
            }
        } else {
            // List of duties
            List {
                ForEach(duties.filter(filterDutiesArray), id: \.self) { duty in
                    NavigationLink(destination: DetailView(duty: duty)) {
                        DutyCard(duty: duty)
                    }
                }
                .onDelete(perform: removeDuty)
            }
        }
    }
    
    /// This method creates the toolbar.
    /// - Returns: Toolbar Content, which contains Toolbar Items - Edit Button and "New Duty" button
    @ToolbarContentBuilder func createToolbar() -> some ToolbarContent {
        // New Duty Button
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(LocalizedStrings.newDuty) {
                withAnimation {
                    self.showingSetupForm = true
                }
            }
            .disabled(showingSetupForm)
        }
        
        // Edit Button
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
                .disabled(showingSetupForm)
        }
    }
}
