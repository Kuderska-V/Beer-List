//
//  ViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 26.10.2022.
//

import UIKit
import Kingfisher

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var beers: [Beer] = []
    var filteredBeers: [Beer] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "https://api.punkapi.com/v2/beers")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                self.beers = try JSONDecoder().decode([Beer].self, from: data)
                self.filteredBeers = self.beers
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBeers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BeerTableViewCell else {
            fatalError()
        }
        let beer = filteredBeers[indexPath.row]
        cell.name.text = beer.name
        cell.year.text = beer.first_brewed
        let url = URL(string: beer.image_url)
        cell.beerImage.kf.setImage(with: url)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.beer = filteredBeers[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: Search Bar Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredBeers = beers
        } else {
            filteredBeers = beers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

