//
//  CategoryCell.swift
//  izibook-API
//
//  Created by Anton Larchenko on 10.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    var openCategoryCallBack: (() -> ())?
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UIButton!
    @IBOutlet weak var chevronImageView: UIImageView!
    
    static let identifier = "CategoryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func categoryButton(_ sender: UIButton) {
        openCategoryCallBack?()
    }
    
}
