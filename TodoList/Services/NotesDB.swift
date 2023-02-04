//
//  NotesDB.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 26.01.23.
//

import Foundation
import Combine

protocol NotesDB {
    func fetchData() -> [TodoItem]
    func addData(title: String, description: String?, dueDate: Date?)
    func updateData(id: String, item: TodoItem)
    func deleteData(at indexSet: IndexSet)
}
