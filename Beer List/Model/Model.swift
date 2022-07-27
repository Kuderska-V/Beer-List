//
//  Model.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 09.07.2022.
//

import Foundation

struct Model: Codable {
    let data: [ModelItem]
}

struct ModelItem: Codable {
    var id: Int
    var name: String
    var tagline: String
    var first_brewed: String
    var description: String
    var image_url: String
}


