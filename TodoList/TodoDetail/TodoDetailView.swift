//
//  TodoDetailView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 12.01.23.
//

import SwiftUI

struct TodoDetailView: View {

    @ObservedObject var viewModel: TodoDetailDefaultViewModel

    init(viewModel: TodoDetailDefaultViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {

            TextField("Todo", text: $viewModel.title)

            if viewModel.item.desc != nil {
                TextField("Description", text: $viewModel.description)
            }

            if viewModel.item.dueDate != nil {
                DatePicker("Due Date", selection: $viewModel.dueDate)
            }

            Text("Last Change: \(viewModel.item.createdAt, formatter: dateFormatter)")
        }
        .navigationTitle(viewModel.item.title)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear{
            viewModel.updateData()
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
            viewModel: TodoDetailDefaultViewModel(
                item: TodoItem(
                    title: "Title",
                    createdAt: .now
                )
            )
        )
    }
}
