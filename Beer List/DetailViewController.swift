//
//  DetailViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 10.07.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageBeer: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionBeer: UITextView!
    
    var beerItem: ModelItem!
    var favBeer:[String] = []
    
    var fav:[ModelItem] = []
    var all:[ModelItem] = []
    
    var favoriteButtonItem: UIBarButtonItem?
    var isFavorite: Bool = false
    var favoriteImage: UIImage? {
        return UIImage(systemName: "star" + (isFavorite ? ".fill" : ""))
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = beerItem.name
        favoriteButtonItem = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
        
        //imageBeer.image = beerItem.image_url
        nameLabel.text = beerItem.name
        yearLabel.text = beerItem.first_brewed
        taglineLabel.text = beerItem.tagline
        descriptionBeer.text = beerItem.description
        
        toggleFavorite()
    }
    
    func saveArray() {
        defaults.set(favBeer, forKey: "isSaved")
        print(favBeer)
    }
    
//    func retriveArray() {
//        var savedData = defaults.object(forKey: "isSaved") as? [String] ?? []
//        savedData.append(contentsOf: favBeer)
//        print(favBeer)
//    }
    
    @objc func toggleFavorite() {
        isFavorite = !isFavorite
        favoriteButtonItem?.image = favoriteImage
        
        if isFavorite == false {
            favoriteButtonItem?.image = UIImage(systemName: "star.fill")
            fav.removeAll()
            
            favBeer.append(beerItem.name)
            favBeer.append(beerItem.first_brewed)
            favBeer.append(beerItem.tagline)
            favBeer.append(beerItem.description)
            saveArray()
            //print(favBeer)
        } else if isFavorite == true {
            favoriteButtonItem?.image = UIImage(systemName: "star")
            favBeer.removeAll()
        }
      
    }
    
}
