//
//  TodoListView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 13.01.23.
//

import SwiftUI

struct TodoListView: View {

    @ObservedObject var viewModel: TodoListViewModel

    init(viewModel: TodoListViewModel = TodoListViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(
                viewModel.todos
            ) { item in
                NavigationLink {
                    TodoDetailView(item: item)
                } label: {
                    TodoItemCellView(title: item.title)
                }
            }
            .onDelete(perform: viewModel.deleteData)
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
