//
//  FavoriteViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 17.07.2022.
//

import UIKit

class FavoriteViewController: UITableViewController {

    var beers:[ModelItem] = []
    let favouritesManager = FavouritesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beers = favouritesManager.beers
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FavoriteTableViewCell
        let beer = beers[indexPath.row]
        cell?.name.text = beer.name
        cell?.year.text = beer.first_brewed
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
