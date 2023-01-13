//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 08.01.23.
//

import FirebaseFirestore
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {

    @Published var todos = [TodoItem]() // Reference to our Model
    @ObservedObject private var db = NotesDatabase()

    private var cancellables = Set<AnyCancellable>()

    // function to post data
    func addData(title: String, dueDate: Date) {
        db.addData(title: title, dueDate: dueDate)
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
    func updateData(title: String, id: String) {
        db.updateData(title: title, id: id)
    }

    // function to delete data
    func deleteData(at indexSet: IndexSet) {
        db.deleteData(at: indexSet)
    }

}
