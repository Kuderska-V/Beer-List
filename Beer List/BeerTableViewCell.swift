//
//  BeerTableViewCell.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 09.07.2022.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet var year: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
