//
//  FavoriteViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 17.07.2022.
//

import UIKit
import Kingfisher

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beers = favouritesManager.beers
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.beerItem = beers[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
