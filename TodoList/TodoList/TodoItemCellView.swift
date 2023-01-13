//
//  TodoItemCellView.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 12.01.23.
//

import SwiftUI

struct TodoItemCellView: View {

    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
                .foregroundColor(.primary)
        }
    }
}

struct TodoItemCellView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemCellView(title: "Title")
            .border(.black)
    }
}
