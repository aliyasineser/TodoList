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
    case coreData
}

final class NotesDatabaseFactory {

    func create(type: DBTypes = .coreData) -> any NotesDB {
        switch type {
        case .firebase:
            return NotesFirestoreDB()
        case .userDefaults:
            return NotesUserDefaultDB()
        case .coreData:
            return NotesCoreDataDB()
        }
    }

}
