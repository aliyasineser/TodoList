//
//  NotesCoreDataDB.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 30.01.23.
//

import Foundation
import CoreData

final class NotesCoreDataDB: NotesDB {
    var todos: [TodoItem] = []

    let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    init() { /* Do Not Implement */ }

    func fetchData() -> [TodoItem] {

        let request = TodoItemCD.fetchRequest()
        do {
            let items = try viewContext.fetch(request)
            todos = items.compactMap {
                guard let id = $0.id, let createdAt = $0.createdAt, let title = $0.title else { return nil }
                return TodoItem(id: id, title: title, desc: $0.desc, createdAt: createdAt, dueDate: $0.dueDate)
            }
        } catch {
            fatalError("Failed to delete note: \(error)")

        }
        return todos
    }

    func addData(title: String, description: String?, dueDate: Date?) {
        let createdAt = Date()
        let item = TodoItem(id: UUID().uuidString, title: title, desc: description, createdAt: createdAt, dueDate: dueDate)
        let itemCoreData = TodoItemCD(context: viewContext)
        itemCoreData.id = item.id
        itemCoreData.title = item.title
        itemCoreData.desc = item.desc
        itemCoreData.createdAt = item.createdAt
        itemCoreData.dueDate = item.dueDate
        todos.append(item)
        saveContext()
    }

    func updateData(id: String, item: TodoItem) {
        let request: NSFetchRequest<TodoItemCD> = TodoItemCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as String)
        do {
            let result = try viewContext.fetch(request)
            guard let cdItem = result.first else { return }
            cdItem.id = item.id
            cdItem.title = item.title
            cdItem.desc = item.desc
            cdItem.createdAt = item.createdAt
            cdItem.dueDate = item.dueDate
        } catch {
            fatalError("Failed to check if note present: \(error)")
        }
        saveContext()
    }

    func deleteData(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let request = TodoItemCD.fetchRequest()
            request.fetchLimit =  1
            guard let id: String = todos[index].id else { return }
        request.predicate = NSPredicate(format: "id == %@", id as String)
            do {
                let result = try viewContext.fetch(request)
                guard let cdItem = result.first else { return }
                viewContext.delete(cdItem)
                todos.remove(at: index)
            } catch {
                fatalError("Failed to check if note present: \(error)")
            }
        }

        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
