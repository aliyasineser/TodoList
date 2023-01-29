//
//  NotesUserDefaultDB.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 26.01.23.
//

import Foundation

final class NotesUserDefaultDB: NotesDB {
    @Published var todos: [TodoItem] = []

    private let defaults = UserDefaults.standard
    private let key = "TodoList"

    func fetchData() -> Published<[TodoItem]>.Publisher {
        if let fetchedData = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let fetchedTodos = try? decoder.decode([TodoItem].self, from: fetchedData) {
                todos = fetchedTodos
            }
        }
        return $todos
    }

    func addData(title: String, description: String?, dueDate: Date?) {
        let createdAt = Date()
        todos.append(TodoItem(id: UUID().uuidString, title: title, desc: description, createdAt: createdAt, dueDate: dueDate))
        if let encoded = try? JSONEncoder().encode(todos) {
            defaults.set(encoded, forKey: key)
        }
    }

    func updateData(id: String, item: TodoItem) {
        guard let index = todos.indices.firstIndex(where: { todos[$0].id == item.id }) else { return }
        todos[index] = item
        defaults.set(todos, forKey: key)
    }

    func deleteData(at indexSet: IndexSet) {
        indexSet.forEach { index in
            todos.remove(at: index)
        }
        defaults.set(todos, forKey: key)
    }
}
