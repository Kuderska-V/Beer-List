//
//  ViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 09.07.2022.
//
import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var beers: [ModelItem] = []
    var filteredBeers: [ModelItem] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        parseJSON()
    }
        
    func parseJSON() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            beers = try JSONDecoder().decode(Model.self, from: jsonData).data
            filteredBeers = beers
        } catch {
            print("Error: \(error)")
        }
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.beerItem = filteredBeers[indexPath.row]
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
