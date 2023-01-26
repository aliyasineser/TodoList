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

    @ObservedObject private var viewModel: TodoListViewModelImpl

    @State var todoPrompt: String = ""
    @State var dueDate: Date = Date()
    @State var description: String = ""
    @State var isPrompting: Bool = false

    init() {
        self.viewModel = TodoListViewModelImpl(
            db: NotesDatabaseFactory().create()
        )
        viewModel.fetchData()
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack() {
                        TodoItemTextField(todoPrompt: $todoPrompt, isPrompting: $isPrompting)
                        TodoItemAddButton(todoPrompt: $todoPrompt, isPrompting: $isPrompting, description: $description, dueDate: $dueDate) { title, description, dueDate in
                            viewModel.addData(title: title, description: description, dueDate: dueDate)
                        }
                    }
                    TodoItemDetailField(description: $description, dueDate: $dueDate, isPrompting: $isPrompting)
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

// MARK: TodoItemDetailField
private struct TodoItemDetailField: View {
    @Binding var description: String
    @Binding var dueDate: Date
    @Binding var isPrompting: Bool

    var body: some View {
        if isPrompting {
            TextField("Description", text: $description)
            DatePicker("Due Date", selection: $dueDate)
        }
    }

}

// MARK: TodoItemTextField
private struct TodoItemTextField: View {
    @Binding var todoPrompt: String
    @Binding var isPrompting: Bool

    var body: some View {
        TextField("Todo", text: $todoPrompt)
            .onTapGesture {
                withAnimation {
                    isPrompting = true
                }
            }
            .onDisappear {
                withAnimation {
                    isPrompting = false
                }
            }
    }
}

// MARK: TodoItemAddButton
private struct TodoItemAddButton: View {
    @Binding var todoPrompt: String
    @Binding var isPrompting: Bool
    @Binding var description: String
    @Binding var dueDate: Date
    var addData: ((String, String?, Date?) -> Void)

    var body: some View {
        Button {
            addData(
                todoPrompt,
                description.isEmpty ? nil : description,
                dueDate
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
}

// MARK: AddItemButton
private struct AddItemButton: View {
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
