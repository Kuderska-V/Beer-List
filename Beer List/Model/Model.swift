//
//  Model.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 09.07.2022.
//

import Foundation
import CoreData

struct ModelItem: Codable {
    var id: Int
    var name: String
    var tagline: String
    var first_brewed: String
    var description: String
    var image_url: String
}

struct SingleBeer: Codable {
    var id: Int
    var tagline: String
    var description: String
}

struct Beer: Codable {
    var id: Int
    var name: String
    var first_brewed: String
    var image_url: String
    
    static func from(_ object: NSManagedObject) -> Beer {
        let id = object.value(forKeyPath: "id") as! Int
        let name =  object.value(forKeyPath: "name") as? String
        let year = object.value(forKeyPath: "year") as? String
        let imageURL = object.value(forKeyPath: "image") as? String
        return Beer(id: id, name: name ?? "Unknow", first_brewed: year ?? "Unknown", image_url: imageURL ?? "")
    }
    
    static func toManagedObject(beer: Beer, entity: NSEntityDescription, context: NSManagedObjectContext) -> NSManagedObject {
        let beerManagedObject = NSManagedObject(entity: entity, insertInto: context)
        beerManagedObject.setValue(beer.id, forKeyPath: "id")
        beerManagedObject.setValue(beer.name, forKeyPath: "name")
        beerManagedObject.setValue(beer.first_brewed, forKeyPath: "year")
        beerManagedObject.setValue(beer.image_url, forKeyPath: "image")
        return beerManagedObject
    }
}


