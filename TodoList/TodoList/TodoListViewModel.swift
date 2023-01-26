//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 13.01.23.
//

import FirebaseFirestore
import SwiftUI
import Combine

protocol TodoListViewModel: ObservableObject {
    var todos: [TodoItem] { get set }

    func fetchData()
    func addData(title: String, description: String?, dueDate: Date?)
    func updateData(id: String, item: TodoItem)
    func deleteData(at indexSet: IndexSet)
}

final class TodoListViewModelImpl: TodoListViewModel{

    @Published var todos = [TodoItem]() // Reference to our Model
    var db: any NotesDB

    init(db: any NotesDB) {
        self.db = db
    }

    private var cancellables = Set<AnyCancellable>()

    // function to post data
    func addData(title: String, description: String?, dueDate: Date?) {
        db.addData(title: title, description: description, dueDate: dueDate)
    }

    // function to read data
    func fetchData() {
        db.fetchData()
            .sink { updatedTodoList in
                self.todos = updatedTodoList
            }
            .store(in: &cancellables)
    }

    // function to update data
    func updateData(id: String, item: TodoItem) {
        db.updateData(id: id, item: item)
    }

    // function to delete data
    func deleteData(at indexSet: IndexSet) {
        db.deleteData(at: indexSet)
    }

}
