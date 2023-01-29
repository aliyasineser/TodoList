//
//  TodoItem.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 08.01.234.
//

import Foundation
import FirebaseFirestoreSwift

struct TodoItem: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var desc: String?
    var createdAt: Date
    var dueDate: Date?
}


struct TodoItemAdapter: Identifiable, Codable, Hashable {
    var id: String?
    var title: String
    var desc: String?
    var createdAt: Date
    var dueDate: Date?
}
