//
//  RandomViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 12.07.2022.
//

import UIKit
import Kingfisher

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
        
        imageRandom.isHidden = true
        nameRandom.isHidden = true
        yearRandom.isHidden = true
        taglineRandom.isHidden = true
        descriptionRandom.isHidden = true
        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "https://api.punkapi.com/v2/beers/random")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                self.beers = try JSONDecoder().decode([ModelItem].self, from: data)
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        task.resume()
    }
        
    @IBAction func tapRandomButton(_ sender: UIButton) {
        fetchData()
        let beer = beers.randomElement()
        beerItem = beer!
        title = beerItem.name
        let favouriteImageName = favouritesManager.isFavourite(beerItem.id) ? "star.fill" : "star"
        favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: favouriteImageName), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
        
        self.imageRandom.isHidden = false
        self.nameRandom.isHidden = false
        self.yearRandom.isHidden = false
        self.taglineRandom.isHidden = false
        self.descriptionRandom.isHidden = false
        let url = URL(string: beer!.image_url)
        self.imageRandom.kf.setImage(with: url!)
        self.nameRandom.text = beer!.name
        self.yearRandom.text = beer!.first_brewed
        self.taglineRandom.text = beer!.tagline
        self.descriptionRandom.text = beer!.description

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
        
    
    


