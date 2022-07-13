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
    
    var result: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random"
        
        parseJSON()
        
    }
    
    func parseJSON() {
        
        guard let path = Bundle.main.path(forResource: "file", ofType: "json") else { return }

        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            result = try JSONDecoder().decode(Model.self, from: jsonData)
        } catch {
            print("Error: \(error)")
            }
        }
        
    
    
        @IBAction func tapRandomButton(_ sender: Any) {
    
    
        }
        

    }
        
    
    


