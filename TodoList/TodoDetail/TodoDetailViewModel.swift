//
//  TodoDetailViewModel.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 19.01.23.
//

import Foundation
import Combine

protocol TodoDetailViewModel: ObservableObject {

    func onAppear()

    var item: TodoItem { get }
    var title: String { get set }
    var dueDate: Date { get set }
    var description: String { get set }
}

final class TodoDetailViewModelImpl: TodoDetailViewModel {

    private var db: any NotesDB
    @Published var item: TodoItem

    private var cancellables = Set<AnyCancellable>()

    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""

    init(item: TodoItem, db: any NotesDB) {
        self.item = item
        self.db = db
        
        self.title = item.title
        if let desc = item.desc { self.description = desc }
        if let dueDate = item.dueDate { self.dueDate = dueDate }

        onAppear()
    }

    func onAppear() {
        subscribeFields()
    }

    private func subscribeFields() {
//        subscribeTitle()
//        subscribeDescription()
//        subscribeDueDate()
        Publishers.CombineLatest3($title, $description, $dueDate)
            .dropFirst(3)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] title, description, dueDate in
                guard let self = self else { return }
                self.item = TodoItem(
                    id: self.item.id,
                    title: title,
                    desc: description,
                    createdAt: self.item.createdAt, // ignored
                    dueDate: dueDate
                )
                self.updateItem(
                    item: self.item
                )
            }
            .store(in: &cancellables)
    }

    private func subscribeTitle() {

        $title
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] title in
                guard let self = self else { return }
                self.item = TodoItem(
                    id: self.item.id,
                    title: title,
                    desc: self.item.desc,
                    createdAt: self.item.createdAt, // ignored
                    dueDate: self.item.dueDate
                )
                self.updateItem(
                    item: self.item
                )
            }
            .store(in: &cancellables)
    }

    private func subscribeDescription() {
        $description
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] description in
                guard let self = self else { return }
                self.item = TodoItem(
                    id: self.item.id,
                    title: self.item.title,
                    desc: description,
                    createdAt: self.item.createdAt, // ignored
                    dueDate: self.item.dueDate
                )
                self.updateItem(
                    item: self.item
                )
            }
            .store(in: &cancellables)
    }

    private func subscribeDueDate() {
        $dueDate
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] dueDate in
                guard let self = self else { return }
                self.item = TodoItem(
                    id: self.item.id,
                    title: self.item.title,
                    desc: self.item.desc,
                    createdAt: self.item.createdAt, // ignored
                    dueDate: dueDate
                )
                self.updateItem(
                    item: self.item
                )
            }
            .store(in: &cancellables)
    }

    private func updateItem(item: TodoItem) {
        guard let id = item.id else { return }
        db.updateData(
            id: id,
            item: item
        )
    }
}
