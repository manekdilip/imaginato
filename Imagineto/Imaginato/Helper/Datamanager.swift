//
//  Datamanager.swift
//  Imaginato
//


import UIKit
import CoreData

class Datamanager: NSObject {
    static let shared = Datamanager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataItems")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}

func createData(arrIemData:[DairytemModel]){
    //We need to create a context from this container
    let managedContext = Datamanager.shared.persistentContainer.viewContext
    //Now let’s create an entity and new user records.
    let userEntity = NSEntityDescription.entity(forEntityName: "ItemDairy", in: managedContext)!
    for itemData in arrIemData{
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(itemData.id, forKeyPath: "id")
        user.setValue(itemData.title, forKey: "title")
        user.setValue(itemData.content, forKey: "content")
        user.setValue(itemData.date, forKey: "date")
    }
    //Now we have set all the values. The next step is to save them inside the Core Data
    do {
        try managedContext.save()
        
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}
func retrieveData() -> [DairytemModel] {
    var arrDataitems = [DairytemModel]()
    let managedContext = Datamanager.shared.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemDairy")
    do {
        let result = try managedContext.fetch(fetchRequest)
        for itemData in result as! [NSManagedObject] {
            let keys = Array(itemData.entity.attributesByName.keys)
            let dict = itemData.dictionaryWithValues(forKeys: keys)
            let modelItem = DairytemModel(withJason:dict as! [String : Any] )
            arrDataitems.append(modelItem)
        }
        return arrDataitems
    } catch {
        print("Failed")
        return arrDataitems
    }
}

func updateData(aItem:DairytemModel){
    let managedContext = Datamanager.shared.persistentContainer.viewContext
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ItemDairy")
    fetchRequest.predicate = NSPredicate(format: "id = %@", aItem.id)
    do{
        let test = try managedContext.fetch(fetchRequest)
        let objectUpdate = test[0] as! NSManagedObject
        objectUpdate.setValue(aItem.id, forKey: "id")
        objectUpdate.setValue(aItem.title, forKey: "title")
        objectUpdate.setValue(aItem.content, forKey: "content")
        objectUpdate.setValue(aItem.date, forKey: "date")
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
    }
    catch{
        print(error)
    }
}

func deleteData(aItem:DairytemModel){
    let managedContext = Datamanager.shared.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemDairy")
    fetchRequest.predicate = NSPredicate(format: "id = %@", aItem.id)
    do{
        let test = try managedContext.fetch(fetchRequest)
        let objectToDelete = test[0] as! NSManagedObject
        managedContext.delete(objectToDelete)
        do{
            try managedContext.save()
        }catch
        {
            print(error)
        }
    } catch {
        print(error)
    }
}

