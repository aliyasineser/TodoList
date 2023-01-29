//
//  TodoDetailView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 12.01.23.
//

import SwiftUI

struct TodoDetailView<ViewModel>: View where ViewModel: TodoDetailViewModel {

    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            TextField("Todo", text: $viewModel.title)
            TextField("Description", text: $viewModel.description)
            DatePicker("Due Date", selection: $viewModel.dueDate)
            Text("Last Change: \(viewModel.item.createdAt, formatter: dateFormatter)")
        }
        .onAppear(perform: viewModel.onAppear)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailView(
            viewModel: TodoDetailViewModelImpl(
                item: TodoItem(
                    title: "Title",
                    createdAt: .now
                ),
                db: NotesDatabaseFactory().create()
            )
        )
    }
}
