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
    
    var beer: Beer!
    var singleBeer: SingleBeer!
    var singleBeers: [SingleBeer] = []
    var favoriteButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        title = beer.name
        let url = URL(string: beer.image_url)
        imageBeer.kf.setImage(with: url)
        nameLabel.text = beer.name
        yearLabel.text = beer.first_brewed
        taglineLabel.text = ""
        descriptionBeer.text = ""
        // change image because of beer state
        favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
    }
    
    func fetchData() {
        let url = URL(string: "https://api.punkapi.com/v2/beers")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                self.singleBeers = try JSONDecoder().decode([SingleBeer].self, from: data)
                
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

    @objc func toggleFavorite() {
        
        // check if beer alrady store
        // if yes, remove it from core data
        // if no save()
        
        
        save()
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Beer", in: managedContext)!
        _ = Beer.toManagedObject(beer: beer, entity: entity, context: managedContext)
       
        do {
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
       
    }
}
