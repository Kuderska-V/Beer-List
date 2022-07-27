//
//  FavouritesManager.swift
//  Beer List
//
//  Created by Svyat Zubyak on 27.07.2022.
//

import Foundation

class FavouritesManager {
    static let shared = FavouritesManager()
    private init() { }
    
    var beers: [ModelItem] = []
    
    func addToFavourites(_ beer: ModelItem) {
        beers.append(beer)
    }
    
    func removeFromFavourites(_ id: Int) {
        guard let index = beers.firstIndex(where: { $0.id == id }) else { return }
        beers.remove(at: index)
    }
    
    func isFavourite(_ id: Int) -> Bool {
        beers.firstIndex(where: { $0.id == id }) != nil
    }
}
