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
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func fetchData() -> Published<[TodoItem]>.Publisher {
        guard let fetchedData = defaults.data(forKey: "TodoList") else { return $todos }

        if let fetchedTodos = try? decoder.decode([TodoItemAdapter].self, from: fetchedData) {
            todos = fetchedTodos.map{ TodoItem(id: $0.id, title: $0.title, desc: $0.desc, createdAt: $0.createdAt, dueDate: $0.dueDate)}
        } else {
            updateDefaults()
        }

        return $todos
    }

    func addData(title: String, description: String?, dueDate: Date?) {
        let createdAt = Date()
        todos.append(TodoItem(id: UUID().uuidString, title: title, desc: description, createdAt: createdAt, dueDate: dueDate))
        updateDefaults()
    }

    func updateData(id: String, item: TodoItem) {
        guard let index = todos.indices.firstIndex(where: { todos[$0].id == item.id }) else { return }
        todos[index] = item
        updateDefaults()
    }

    func deleteData(at indexSet: IndexSet) {
        indexSet.forEach { index in
            todos.remove(at: index)
        }
        updateDefaults()
    }

    private func updateDefaults() {
        do {
            let adaptedTodos = todos.map{ TodoItemAdapter(id: $0.id, title: $0.title, desc: $0.desc, createdAt: $0.createdAt, dueDate: $0.dueDate)}
            let encoded = try encoder.encode(adaptedTodos)
            defaults.set(encoded, forKey: "TodoList")
            defaults.synchronize()
        } catch {
#if DEBUG
            print(error)
#endif
        }
    }
}
