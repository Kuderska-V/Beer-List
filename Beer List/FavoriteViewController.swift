//
//  FavoriteViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 17.07.2022.
//

import UIKit
import Kingfisher
import CoreData

class FavoriteViewController: UITableViewController {

    var beers: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getFavouriteBeers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Beer")
        

        do {
          beers = try managedContext.fetch(fetchRequest)
          
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavouriteBeers()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FavoriteTableViewCell
        let beerManagedObject = beers[indexPath.row]
        let beer = Beer.from(beerManagedObject)
        let url = URL(string: beer.image_url)
        cell?.imageFav.kf.setImage(with: url)
        cell?.name.text = beer.name
        cell?.year.text = beer.first_brewed
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let beerManagedObject = beers[indexPath.row]
            vc.beer = Beer.from(beerManagedObject)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
