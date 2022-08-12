//
//  DetailViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 10.07.2022.
//

import UIKit
import Kingfisher
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var imageBeer: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionBeer: UITextView!
    
    var beerItem: ModelItem!
    var favoriteButtonItem: UIBarButtonItem?
    
    var beer: [NSManagedObject] = []
    
    let favouritesManager = FavouritesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = beerItem.name
        let url = URL(string: beerItem.image_url)
        imageBeer.kf.setImage(with: url)
        nameLabel.text = beerItem.name
        yearLabel.text = beerItem.first_brewed
        taglineLabel.text = beerItem.tagline
        descriptionBeer.text = beerItem.description
        let favouriteImageName = favouritesManager.isFavourite(beerItem.id) ? "star.fill" : "star"
        favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: favouriteImageName), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
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
