//
//  ViewController.swift
//  izibook-API
//
//  Created by Anton Larchenko on 10.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let webManager = WebManager()
    var catalogElement: CatalogElement?

    @IBOutlet weak var myTableView: UITableView!
        
    var sections = [
        
        SectionData(
            open: false,
            data: [
                CellData(title: "Subcategory1"),
                CellData(title: "Subcategory2")
                ]
        ),
        
        SectionData(
        open: false,
        data: [
            CellData(title: "Subcategory3")
            ]
        ),
        
        SectionData(
        open: false,
        data: [
            CellData(title: "Subcategory4"),
            CellData(title: "Subcategory5")
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webManager.getCertificate { [weak self] (certificate) in
            
        }
        
        webManager.getCatalog { [weak self] (catalog) in
            
        }
        
        webManager.loadImage(imageId: catalogElement?.icon ?? "18", height: "50", width: "50") { [weak self] (images) in
            
        }
        
        myTableView.register(UINib(nibName: SubcategoryCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: SubcategoryCell.identifier)
        myTableView.register(UINib(nibName: CategoryCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: CategoryCell.identifier)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryCell.identifier)
        let cellHeight = cell?.frame.size.height
        return cellHeight!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as! CategoryCell
        
        cell.openCategoryCallBack = { [unowned self] in
            cell.categoryLabel.tag = section
            let section = cell.categoryLabel.tag
            var indexPaths = [IndexPath]()
            for row in self.sections[section].data.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
            
            let open = self.sections[section].open
            self.sections[section].open = !open
            
            cell.chevronImageView.image = open ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
            
            if open {
                self.myTableView.deleteRows(at: indexPaths, with: .fade)
            } else {
                self.myTableView.insertRows(at: indexPaths, with: .fade)
            }

        }
        
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier)
        let cellHeight = cell?.frame.size.height
        return cellHeight!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 1))
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !sections[section].open {
            return 0
        }
        return sections[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryCell.identifier, for: indexPath) as! SubcategoryCell
        let section = sections[indexPath.section]
        cell.subcategoryLabel.setTitle(section.data[indexPath.row].title, for: .normal)
        
        return cell
    }
    
    
}
