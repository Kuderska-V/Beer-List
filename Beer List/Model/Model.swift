//
//  Model.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 09.07.2022.
//

import Foundation
import CoreData

struct Beer: Codable {
    var id: Int
    var name: String
    var first_brewed: String
    var image_url: String
    var tagline: String
    var description: String
    var createdAt: Date?
    
    static func from(_ object: NSManagedObject) -> Beer {
        let id = object.value(forKeyPath: "id") as! Int
        let name =  object.value(forKeyPath: "name") as? String
        let year = object.value(forKeyPath: "year") as? String
        let imageURL = object.value(forKeyPath: "image") as? String
        let createdAt = object.value(forKeyPath: "created_at") as? Date
        return Beer(id: id, name: name ?? "Unknown", first_brewed: year ?? "Unknown", image_url: imageURL ?? "", tagline: "", description: "", createdAt: createdAt)
    }
    
    @discardableResult static func toManagedObject(beer: Beer, entity: NSEntityDescription, context: NSManagedObjectContext) -> NSManagedObject {
        let beerManagedObject = NSManagedObject(entity: entity, insertInto: context)
        beerManagedObject.setValue(beer.id, forKeyPath: "id")
        beerManagedObject.setValue(beer.name, forKeyPath: "name")
        beerManagedObject.setValue(beer.first_brewed, forKeyPath: "year")
        beerManagedObject.setValue(beer.image_url, forKeyPath: "image")
        beerManagedObject.setValue(Date(), forKeyPath: "created_at")
        return beerManagedObject
    }
}

struct KeysDefaults {
    static let keyEmail = "email"
    static let keyPassword = "password"
}


