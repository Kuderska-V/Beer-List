//
//  ViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 09.07.2022.
//
import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var result: Model?
    
    
    var filteredData = [String]()
    
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
            result = try JSONDecoder().decode(Model.self, from: jsonData)
        } catch {
            print("Error: \(error)")
            }

        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = result {
            return result.data.count
        }
            return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? BeerTableViewCell else {
            fatalError()
        }
        
        let model = result?.data[indexPath.row]
        cell.name.text = model?.name
        cell.year.text = model?.first_brewed
        cell.imageBeer.image = UIImage(named: model!.image_url)
        
        if let imageURL = URL(string: model!.image_url) {
            if let data = try? Data(contentsOf: imageURL) {
                cell.imageBeer.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
           
            //let model = result?.data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: Search Bar Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {


//        for item in data {
//            if item.name.contains(searchText) {
//                filteredData.append(item)
//            }
//        }
//
//        self.tableView.reloadData()
        
        
//        if searchText == "" {
//            data = result.data!
//            self.tableView.reloadData()
//
//        } else {
//            filteredData = result.filter({$0.name.contains(searchText)})
//            self.tableView.reloadData()
//        }

//
//        if isSearchin {
//            return filteredData.count
//        } else {
//            return result
//        }
//
        
    }

}
