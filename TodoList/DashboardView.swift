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

            List {
                Section("Todo") {
                    TextField("Todo", text: $todoPrompt)
                    Button {
                        viewModel.addData(title: todoPrompt)
                    } label: {
                        Text("Add")
                    }
                }

                Section {
                    ForEach(viewModel.todos) { item in
                        NavigationLink {
                            List {
                                Text("Todo: \(item.title)")
                                if let desc = item.desc {
                                    Text("\(desc)")
                                }
                                Text("Item at \(item.createdAt, formatter: itemFormatter)")
                            }
                        } label: {
                            Text(item.title)
                        }
                    }
                    .onDelete(perform: viewModel.deleteData)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        viewModel.addData(title: todoPrompt)
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .onAppear(perform: viewModel.fetchData)
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
