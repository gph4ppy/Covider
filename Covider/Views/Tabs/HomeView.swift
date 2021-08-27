//
//  HomeView.swift
//  Covider
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 20/08/2021.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSetupForm: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Duty.startDate,
                             ascending: true)
        ],
        animation: .default
    ) private var duties: FetchedResults<Duty>
    
    // I use the overlay variable because the opacity change
    // using the ternary operator in the .overlay modifier, for some reason,
    // disabled the functionality of the application in dark mode
    // (the ToolbarItems did not work).
    var overlay: some View {
        Color.primary
            .opacity(0.4)
            .ignoresSafeArea()
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                listView
                    .navigationBarTitle(LocalizedStrings.duties)
                    .toolbar(content: createToolbar)
                    .navigationViewStyle(StackNavigationViewStyle())
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
    func removeDuty(at offsets: IndexSet) {
        for index in offsets {
            let duty = duties[index]
            viewContext.delete(duty)
            PersistenceController.shared.saveContext()
        }
    }
}

// MARK: - Views
extension HomeView {
    // List or description that duties array does not contain data.
    @ViewBuilder var listView: some View {
        if duties.isEmpty {
            VStack {
                Spacer()
                Text(LocalizedStrings.emptyList)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .opacity(0.2)
                Spacer()
            }
            .padding()
        } else {
            List {
                ForEach(duties, id: \.self) { duty in
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
