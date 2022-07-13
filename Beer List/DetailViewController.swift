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
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBAction func pressButton(_ sender: UIButton) {
        
    }
    
   // var beerItem: ModelItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Beer Details"
        
//        let beer = beerItem.image_url
//        if let imageURL = URL(string: beer) {
//            if let data = try? Data(contentsOf: imageURL) {
//                imageBeer.image = UIImage(data: data)
//            }
//        }
    
//          nameLabel.text = beerItem.name
//        yearLabel.text = "Since:\(beerItem.first_brewed)"
//        taglineLabel.text = beerItem.tagline
//        descriptionBeer.text = beerItem.description
       
    
    }
}
