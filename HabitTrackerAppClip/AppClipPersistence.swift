//
//  AppClipPersistence.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 29/07/25.
//


import CoreData

struct AppClipPersistence {
    static let shared = AppClipPersistence()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "HabitTracker")

        if let groupURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.prodev.habittracker") {
            
            let storeURL = groupURL.appendingPathComponent("HabitTracker.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { response, error in
            if let error = error as NSError? {
                fatalError("Unresolved AppClip Core Data error \(error), \(error.userInfo)")
            }
            
            print(response)
            
        }
    }
}
