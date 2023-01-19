//
//  TodoDetailViewModel.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 19.01.23.
//

import Foundation
import Combine

protocol TodoDetailViewModel {
    func updateData()

    var item: TodoItem { get }
}

final class TodoDetailDefaultViewModel: ObservableObject {
    private var db = NotesDatabase()
    public var item: TodoItem

    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""

    init(item: TodoItem) {
        self.item = item
        
        self.title = item.title
        if let desc = item.desc { self.description = desc }
        if let dueDate = item.dueDate { self.dueDate = dueDate }
    }

    func updateData() {
        if let id = item.id,
            (
                title != item.title ||
                ( item.desc != nil && description != item.desc ) ||
                ( item.dueDate != nil && dueDate != item.dueDate )
            ) {
            db.updateData(
                id: id,
                item: TodoItem(
                    id: item.id,
                    title: title,
                    desc: description,
                    createdAt: item.createdAt, // ignored
                    dueDate: dueDate
                )
            )
        }
    }

}
