//
//  SubcategoryCell.swift
//  izibook-API
//
//  Created by Anton Larchenko on 10.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class SubcategoryCell: UITableViewCell {
        
    @IBOutlet weak var subcategoryLabel: UIButton!
    
    static let identifier = "SubcategoryCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func subcategoryButton(_ sender: UIButton) {
        
    }
    
}
