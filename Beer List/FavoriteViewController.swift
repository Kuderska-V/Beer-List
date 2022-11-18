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

    var beers: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
    }
    
    @IBAction func tapFilterButton(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "SORT BY DATE", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { (action) -> Void in
            self.beers.sort(by: { $0.createdAt! > $1.createdAt!})
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Descending", style: .default, handler: { (action) -> Void in
            self.beers.sort( by: {$0.createdAt! < $1.createdAt!})
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(ac, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getFavouriteBeers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue) as? String else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Beer")
        fetchRequest.predicate = NSPredicate(format: "owner_email == %@", email)
        
        do {
            let beerManagedObjects = try managedContext.fetch(fetchRequest)
            
            beers = beerManagedObjects.map { Beer.from($0) }.sorted {
                return $0.createdAt?.timeIntervalSince1970 ?? 0.0 > $1.createdAt?.timeIntervalSince1970 ?? 0.0
            }
            
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
        let beer = beers[indexPath.row]
        let url = URL(string: beer.image_url)
        cell?.imageFav.kf.setImage(with: url)
        cell?.name.text = beer.name
        cell?.year.text = beer.first_brewed
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllers.detail.rawValue) as? DetailViewController {
            vc.beer = beers[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
