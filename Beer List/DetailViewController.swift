//
//  DetailViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 10.07.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageBeer: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionBeer: UITextView!
    
    var beerItem: ModelItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = beerItem.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        print("add")
    }
}
