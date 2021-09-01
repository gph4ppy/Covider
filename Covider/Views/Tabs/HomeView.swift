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
            NavigationView {
                listView
                    .navigationBarTitle(LocalizedStrings.duties)
                    .toolbar(content: createToolbar)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .add(searchBar)
            }
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
extension HomeView {
    /// This method removes selected duty from the context.
    /// - Parameter offsets: A set of indexes representing elements in the duties array.
    private func removeDuty(at offsets: IndexSet) {
        for index in offsets {
            let duty = duties[index]
            viewContext.delete(duty)
            PersistenceController.shared.saveContext()
        }
    }
    
    /// This method filters an array with duties using the search text, entered in Search Bar.
    /// - Parameter duty: Fetched object, stores data about the duty.
    /// - Returns: A logical value indicates whether a given duty contains the given text. If so, it is displayed in HomeView.
    private func filterDutiesArray(_ duty: Duty) -> Bool {
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
}

// MARK: - Views
extension HomeView {
    // I use the overlay variable because the opacity change
    // using the ternary operator in the .overlay modifier, for some reason,
    // disabled the functionality of the application in dark mode
    // (the ToolbarItems did not work).
    private var overlay: some View {
        Color.primary
            .opacity(0.4)
            .ignoresSafeArea()
    }
    
    // List or description that duties array does not contain data.
    @ViewBuilder private var listView: some View {
        if duties.isEmpty {
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
    @ToolbarContentBuilder private func createToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(LocalizedStrings.newDuty) {
                withAnimation {
                    self.showingSetupForm = true
                }
            }
            .disabled(showingSetupForm)
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
                .disabled(showingSetupForm)
        }
    }
}
