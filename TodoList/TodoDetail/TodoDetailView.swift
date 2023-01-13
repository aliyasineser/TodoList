//
//  TodoDetailView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 12.01.23.
//

import SwiftUI

struct TodoDetailView: View {

    var item: TodoItem

    var body: some View {
        List {
            Text(item.title)
            if let desc = item.desc {
                Text("\(desc)")
            }

            if let dueDate = item.dueDate {
                Text("Due Date: \(dueDate, formatter: dateFormatter)")
            }
            Text("Last Change: \(item.createdAt, formatter: dateFormatter)")
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(
            item: TodoItem(
                title: "Title",
                desc: "Long Description with some Lorem Ipsum Dolor Sit Amet",
                createdAt: Date(),
                dueDate: Date()
            )
        )
    }
}
