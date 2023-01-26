//
//  TodoListView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 13.01.23.
//

import SwiftUI

struct TodoListView<ViewModel>: View where ViewModel: TodoListViewModel {

    @ObservedObject var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(
                viewModel.todos
            ) { item in
                NavigationLink(item.title, value: item)
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
            }
            .onDelete(perform: viewModel.deleteData)
        }
        .onAppear(perform: viewModel.fetchData)
        .navigationDestination(for: TodoItem.self) { item in
            TodoDetailView(
                viewModel: TodoDetailViewModelImpl(
                    item: item,
                    db: NotesDatabaseFactory().create()
                )
            )
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(
            viewModel: TodoListViewModelImpl(db: NotesDatabaseFactory().create())
        )
    }
}
