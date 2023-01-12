//
//  TodoViewModel.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 08.01.23.
//

import FirebaseFirestore
import SwiftUI

class TodoViewModel: ObservableObject {

    @Published var todos = [TodoItem]() // Reference to our Model
    private var databaseReference = Firestore.firestore().collection("todoList-ec71e") // reference to our Firestore's collection
    // function to post data
    func addData(title: String) {
        let createdAt = Date()
        _ = databaseReference.addDocument(data: ["title": title, "createdAt": createdAt])
    }

    // function to read data
    func fetchData() {
        databaseReference.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            withAnimation {
                self.todos = documents.compactMap { queryDocumentSnapshot -> TodoItem? in
                    return try? queryDocumentSnapshot.data(as: TodoItem.self)
                }
            }
        }
    }

    // function to update data
    func updateData(title: String, id: String) {
        databaseReference.document(id).updateData(["title" : title]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Note updated succesfully")
            }
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
