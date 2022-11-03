//
//  RandomViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 12.07.2022.
//

import UIKit
import Kingfisher
import CoreData

class RandomViewController: UIViewController {

    @IBOutlet weak var imageRandom: UIImageView!
    @IBOutlet weak var nameRandom: UILabel!
    @IBOutlet weak var taglineRandom: UILabel!
    @IBOutlet weak var yearRandom: UILabel!
    @IBOutlet weak var descriptionRandom: UITextView!
    
    var beer: Beer?
    var favoriteButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random Beer"
        imageRandom.isHidden = true
        nameRandom.isHidden = true
        yearRandom.isHidden = true
        taglineRandom.isHidden = true
        descriptionRandom.isHidden = true
        tapRandomButton(UIButton())
    }
    
    func fetchRundomBeer(completion: @escaping (Beer?) -> Void) {
        let url = URL(string: "https://api.punkapi.com/v2/beers/random")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                DispatchQueue.main.async {
                    completion(beers.first)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentAlert(with:AlertController.somethingWentWrong.rawValue, message: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
        
    @IBAction func tapRandomButton(_ sender: UIButton) {
        fetchRundomBeer { beer in
            self.beer = beer
            self.configureLayouts()
        }
    }
    
    func configureLayouts() {
        guard let beer = beer else { return }
        title = beer.name
        favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: isAddedToFavourites() ? "star.fill" : "star"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
        imageRandom.isHidden = false
        nameRandom.isHidden = false
        yearRandom.isHidden = false
        taglineRandom.isHidden = false
        descriptionRandom.isHidden = false
        let url = URL(string: beer.image_url)
        imageRandom.kf.setImage(with: url!)
        nameRandom.text = beer.name
        yearRandom.text = beer.first_brewed
        taglineRandom.text = beer.tagline
        descriptionRandom.text = beer.description
    }
    
    @objc func toggleFavorite() {
        if isAddedToFavourites() {
            remove()
        } else {
            save()
        }
    }
    
    func isAddedToFavourites() -> Bool {
        guard let beer = beer else { return false }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Beer")
        fetchRequest.predicate = NSPredicate(format: "id == %d" , beer.id)
        let count = try? managedContext.count(for: fetchRequest)
        guard let count = count else { return false }
        return count > 0
    }
    
    func save() {
        guard let beer = beer else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Beer", in: managedContext)!
        Beer.toManagedObject(beer: beer, entity: entity, context: managedContext)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
    }
    
    func remove() {
        guard let beer = beer else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Beer")
        fetchRequest.predicate = NSPredicate(format: "id == %d" , beer.id)
        let beers = try? managedContext.fetch(fetchRequest)
        guard let beers = beers else { return }
        for beer in beers {
            managedContext.delete(beer)
        }
        try? managedContext.save()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
    }
}
        
extension RandomViewController {
    
    func presentAlert(with title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

    


