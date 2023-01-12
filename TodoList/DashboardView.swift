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
    @ObservedObject var viewModel: TodoViewModel
    @State var dueDate: Date = Date()
    @State var isPrompting: Bool = false

    init(viewModel: TodoViewModel = TodoViewModel()) {
        self.viewModel = viewModel

    }

    var body: some View {
        NavigationView {
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
                            viewModel.addData(title: todoPrompt, dueDate: dueDate)
                            withAnimation {
                                todoPrompt = ""
                                isPrompting = false
                            }
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                    }
                    if isPrompting {
                        DatePicker("Due Date", selection: $dueDate)
                    }

                }
                .padding(.horizontal, 30)


                Divider()
                    .padding(.horizontal)

                List {
                    ForEach(
                        viewModel.todos
                    ) { item in
                        NavigationLink {
                            TodoDetailView(item: item)
                        } label: {
                            TodoItemCellView(title: item.title)
                        }
                    }
                    .onDelete(perform: viewModel.deleteData)
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear(perform: viewModel.fetchData)
            .navigationTitle("Todo List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
