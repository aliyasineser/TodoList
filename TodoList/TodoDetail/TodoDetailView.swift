//
//  TodoDetailView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 12.01.23.
//

import SwiftUI

struct TodoDetailView: View {

    private var item: TodoItem

    @State var title: String = ""
    @State var dueDate: Date = Date()
    @State var description: String = ""

    private var db = NotesDatabase()

    init(item: TodoItem) {
        self.item = item
    }

    var body: some View {
        List {

            TextField("Todo", text: $title)

            if item.desc != nil {
                TextField("Description", text: $description)
            }

            if item.dueDate != nil {
                DatePicker("Due Date", selection: $dueDate)
            }

            Text("Last Change: \(item.createdAt, formatter: dateFormatter)")
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.title = item.title
            if let desc = item.desc { self.description = desc }
            if let dueDate = item.dueDate { self.dueDate = dueDate }
        }
        .onDisappear{
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
