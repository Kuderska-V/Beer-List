//
//  RandomViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 12.07.2022.
//

import UIKit

class RandomViewController: UIViewController {

    @IBOutlet weak var imageRandom: UIImageView!
    @IBOutlet weak var nameRandom: UILabel!
    @IBOutlet weak var taglineRandom: UILabel!
    @IBOutlet weak var yearRandom: UILabel!
    @IBOutlet weak var descriptionRandom: UITextView!
    
    var randomBeer: [ModelItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random"
        parseJSON()
        nameRandom.isHidden = true
        yearRandom.isHidden = true
        taglineRandom.isHidden = true
        descriptionRandom.isHidden = true
    }
    
    func parseJSON() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            randomBeer = try JSONDecoder().decode(Model.self, from: jsonData).data
        } catch {
            print("Error: \(error)")
        }
    }
        
    @IBAction func tapRandomButton(_ sender: Any) {
        let beer = randomBeer.randomElement()
        nameRandom.isHidden = false
        nameRandom.text = beer?.name
        yearRandom.isHidden = false
        yearRandom.text = beer?.first_brewed
        taglineRandom.isHidden = false
        taglineRandom.text = beer?.tagline
        descriptionRandom.isHidden = false
        descriptionRandom.text = beer?.description
    }
}
        
    
    


