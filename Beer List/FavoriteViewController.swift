//
//  FavoriteViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 17.07.2022.
//

import UIKit

class FavoriteViewController: UITableViewController {
    let vc = DetailViewController()

    var beerItem: ModelItem!
    
    var beers:[ModelItem] = []
    var favBeers:[String] = []

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        retriveArray()
        
        tableView.reloadData()

    }
    func retriveArray() {
        var savedData = defaults.object(forKey: "isSaved") as? [String] ?? []
        savedData.append(contentsOf: vc.favBeer)
        favBeers = savedData
        print(favBeers)
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favBeers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FavoriteTableViewCell
        
//        let beer = favBeers[indexPath.row]
//        print(beer)
        cell?.name.text = favBeers[0]
        cell?.year.text = favBeers[1]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }

    }

}
