//
//  RandomViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 12.07.2022.
//

import UIKit

class RandomViewController: UIViewController {

    @IBOutlet weak var imageRandom: UIImageView!
    @IBOutlet weak var nameRandom: UILabel!
    @IBOutlet weak var taglineRandom: UILabel!
    @IBOutlet weak var yearRandom: UILabel!
    @IBOutlet weak var descriptionRandom: UITextView!
    
    var beerItem: ModelItem!
    var beers: [ModelItem] = []
    var favoriteButtonItem: UIBarButtonItem?
    
    let favouritesManager = FavouritesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random Beer"
        parseJSON()
        nameRandom.isHidden = true
        yearRandom.isHidden = true
        taglineRandom.isHidden = true
        descriptionRandom.isHidden = true
        
//        let favouriteImageName = favouritesManager.isFavourite(beerItem!.id) ? "star.fill" : "star"
//    favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: favouriteImageName), style: .plain, target: self, action: #selector(toggleFavorite))

        navigationItem.rightBarButtonItem = favoriteButtonItem
        
    }
    
    func parseJSON() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            beers = try JSONDecoder().decode(Model.self, from: jsonData).data
        } catch {
            print("Error: \(error)")
        }
    }
        
    @IBAction func tapRandomButton(_ sender: UIButton) {

        let beer = beers.randomElement()
        beerItem = beer!
        //print(beerItem!)
            
        nameRandom.isHidden = false
        nameRandom.text = beer!.name
        yearRandom.isHidden = false
        yearRandom.text = beer!.first_brewed
        taglineRandom.isHidden = false
        taglineRandom.text = beer!.tagline
        descriptionRandom.isHidden = false
        descriptionRandom.text = beer!.description
        
        let favouriteImageName = favouritesManager.isFavourite(beerItem!.id) ? "star.fill" : "star"
    favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: favouriteImageName), style: .plain, target: self, action: #selector(toggleFavorite))
    }
    
    @objc func toggleFavorite() {
        if favouritesManager.isFavourite(beerItem.id) {
            favouritesManager.removeFromFavourites(beerItem.id)
            favoriteButtonItem?.image = UIImage(systemName: "star")
        } else {
            favouritesManager.addToFavourites(beerItem)
            favoriteButtonItem?.image = UIImage(systemName: "star.fill")
        }
    }
}
        
    
    


