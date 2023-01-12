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
            Text("Todo: \(item.title)")
            if let desc = item.desc {
                Text("\(desc)")
            }
            Text("Item at \(item.createdAt, formatter: dateFormatter)")
        }
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
                createdAt: Date()
            )
        )
    }
}
