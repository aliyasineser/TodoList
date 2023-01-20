//
//  NotesDatabase.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 13.01.23.
//

import FirebaseFirestore
import SwiftUI

protocol NotesDB: ObservableObject {
    var todos: [TodoItem] { get }

    func fetchData() -> Published<[TodoItem]>.Publisher
    func addData(title: String, description: String?, dueDate: Date?)
    func updateData(id: String, item: TodoItem)
    func deleteData(at indexSet: IndexSet)
}

final class NotesFirestoreDB: NotesDB {

    @Published var todos = [TodoItem]() // Reference to our Model
    private var databaseReference = Firestore.firestore().collection(Constants.Firestore.notes.rawValue) // reference to our Firestore's collection
    // function to post data
    func addData(title: String, description: String?, dueDate: Date?) {
        let createdAt = Date()
        var data: [String: Any] = ["title": title, "createdAt": createdAt]
        if let description { data["desc"] = description }
        if let dueDate { data["dueDate"] = dueDate }
        _ = databaseReference.addDocument(data: data)
    }

    // function to read data
    func fetchData() -> Published<[TodoItem]>.Publisher {
        databaseReference.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.todos = documents.compactMap { queryDocumentSnapshot -> TodoItem? in
                return try? queryDocumentSnapshot.data(as: TodoItem.self)
            }.sorted {$0.createdAt > $1.createdAt}
        }
        return $todos
    }

    // function to update data
    func updateData(id: String, item: TodoItem) {
        let lastChange = Date()
        var data: [String: Any] = ["title": item.title, "createdAt": lastChange]
        if let description = item.desc { data["desc"] = description }
        if let dueDate = item.dueDate { data["dueDate"] = dueDate }

        databaseReference.document(id).updateData(data) { error in
            self.handleError(error)
        }
    }

    private func handleError(_ error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Note updated succesfully")
        }
    }

    // function to delete data
    func deleteData(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = todos[index]
            databaseReference.document(note.id ?? "").delete { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("Note with ID \(note.id ?? "") deleted")
                }
            }
        }
    }
}
