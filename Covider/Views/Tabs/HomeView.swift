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
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(duties, id: \.self) { duty in
                        NavigationLink(destination: DetailView(duty: duty)) {
                            DutyCard(duty: duty)
                        }
                    }
                    .onDelete(perform: removeDuty)
                }
                .overlay(
                    Color.primary
                        .opacity(showingSetupForm ? 0.4 : 0)
                        .ignoresSafeArea()
                )
                
                DutySetupAlert(isVisible: $showingSetupForm)
                    .offset(y: showingSetupForm ? 0 : UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
            .navigationBarTitle("Duties")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New duty") {
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
            .onAppear {
                self.showingSetupForm = false
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func removeDuty(at offsets: IndexSet) {
        for index in offsets {
            let duty = duties[index]
            viewContext.delete(duty)
            PersistenceController.shared.saveContext()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
