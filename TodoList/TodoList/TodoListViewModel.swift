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

    func onAppear()
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

    // function to post data
    func addData(title: String, description: String?, dueDate: Date?) {
        db.addData(title: title, description: description, dueDate: dueDate)
    }

    func onAppear() {
        fetchData()
    }

    // function to read data
    func fetchData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.todos = self.db.fetchData()
        }
    }

    // function to update data
    func updateData(id: String, item: TodoItem) {
        db.updateData(id: id, item: item)
        fetchData()
    }

    // function to delete data
    func deleteData(at indexSet: IndexSet) {
        db.deleteData(at: indexSet)
        fetchData()
    }

}
