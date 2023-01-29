//
//  NotesDatabaseFactory.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 26.01.23.
//

import Foundation

public enum DBTypes {
    case firebase
}

final class NotesDatabaseFactory {

    func create(type: DBTypes = .firebase) -> any NotesDB {
        switch type {
        case .firebase:
            return NotesFirestoreDB()
        }
    }

}
