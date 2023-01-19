//
//  ContentView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 07.01.23.
//

import SwiftUI
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DashboardView: View {
    @State var todoPrompt: String = ""
    private var viewModel: TodoListViewModel
    @State var dueDate: Date = Date()
    @State var description: String = ""
    @State var isPrompting: Bool = false

    init() {
        self.viewModel = TodoListViewModel()
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack() {
                        TextField("Todo", text: $todoPrompt)
                            .onTapGesture {
                                isPrompting = true
                            }
                            .onDisappear {
                                isPrompting = false
                            }

                        Button {
                            viewModel.addData(
                                title: todoPrompt,
                                description: description.isEmpty ? nil : description,
                                dueDate: dueDate
                            )
                            withAnimation {
                                todoPrompt = ""
                                description = ""
                                isPrompting = false
                            }
                        } label: {
                            AddItemButton()
                        }
                    }

                    if isPrompting {
                        TextField("Description", text: $description)
                        DatePicker("Due Date", selection: $dueDate)
                    }
                }
                .padding(.horizontal, 30)

                Divider()
                    .padding(.horizontal)

                TodoListView(viewModel: viewModel)

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Todo List")
        }
    }
}

struct AddItemButton: View {
    var body: some View {
        Image(systemName: "plus")
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
