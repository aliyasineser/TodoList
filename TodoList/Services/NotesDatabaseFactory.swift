//
//  NotesDatabaseFactory.swift
//  TodoList
//
//  Created by Ali Yasin Eser on 26.01.23.
//

import Foundation

public enum DBTypes {
    case firebase
    case userDefaults
}

final class NotesDatabaseFactory {

    func create(type: DBTypes = .userDefaults) -> any NotesDB {
        switch type {
        case .firebase:
            return NotesFirestoreDB()
        case .userDefaults:
            return NotesUserDefaultDB.shared
        }
    }

}
