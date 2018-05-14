//
//  CoreDataHelper.swift
//  CoreNotes
//
//  Created by 1 on 14/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        return context
    }()
    
    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        saveNote()
        return note
    }
    
    static func getNotes(searchText: String?, filter: Int) -> [Note] {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        let strippedText = searchText?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        if !strippedText.isEmpty {
            let bodyPredicate = NSPredicate(format: "body CONTAINS[c] %@", strippedText)
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", strippedText)
            let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [bodyPredicate, titlePredicate])
            fetchRequest.predicate = orPredicate
        } else {
            fetchRequest.predicate = nil
        }
        
        switch filter {
        case 0:
            let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        case 1:
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        default:
            print("unexpected filter")
            fetchRequest.sortDescriptors = []
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("cant fetch \(error.localizedDescription)")
            return []
        }
    }
    
    static func delete(note: Note) {
        context.delete(note)
        saveNote()
    }
    
    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("error save context \(error.localizedDescription)")
        }
    }
}
