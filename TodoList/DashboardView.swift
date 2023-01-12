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

    init(viewModel: TodoViewModel = TodoViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack() {
                    TextField("Todo", text: $todoPrompt)
                        .padding()

                    Button {
                        viewModel.addData(title: todoPrompt)
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                }

                .padding(.horizontal, 20)

                Divider()
                    .padding(.horizontal)

                List {
                    ForEach(viewModel.todos.sorted { $0.createdAt > $1.createdAt}) { item in
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
