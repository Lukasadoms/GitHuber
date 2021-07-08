
import Foundation
import CoreData

class CoreDataManager {

    private static let modelName = "GitHuber"
    
    static var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    private static var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static func saveContext() throws {
        guard managedContext.hasChanges else { return }
        
        try managedContext.save()
    }
}
