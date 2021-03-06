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
    var catalogElement = [CatalogElement]()

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webManager.getCertificate { [weak self] (certificate) in
            self?.webManager.getCatalog { [weak self] (catalog) in
                self?.catalogElement = catalog!.data
                self?.myTableView.reloadData()
            }
        }
        
        myTableView.register(UINib(nibName: SubcategoryCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: SubcategoryCell.identifier)
        myTableView.register(UINib(nibName: CategoryCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: CategoryCell.identifier)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return catalogElement.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as! CategoryCell
        
        cell.categoryImageView.layer.cornerRadius = cell.categoryImageView.frame.size.height/2
        cell.categoryLabel.setTitle(catalogElement[section].title, for: .normal)
        let popularity = catalogElement[section].popularity
        cell.chevronImageView.image = popularity ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        
        cell.openCategoryCallBack = { [unowned self] in
            cell.categoryLabel.tag = section
            let section = cell.categoryLabel.tag
            var indexPaths = [IndexPath]()
            for row in self.catalogElement[section].items.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
            
            let popularity = self.catalogElement[section].popularity
            self.catalogElement[section].popularity = !popularity
            
            cell.chevronImageView.image = popularity ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
            
            if popularity {
                self.myTableView.deleteRows(at: indexPaths, with: .fade)
            } else {
                self.myTableView.insertRows(at: indexPaths, with: .fade)
            }
            
        }
        
        webManager.loadImage(imageId: catalogElement[section].icon, height: "100", width: "100") { (images) in
            cell.categoryImageView.image = images.image
        }
        
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 82
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
        if !catalogElement[section].popularity {
            return 0
        }
        return catalogElement[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubcategoryCell.identifier, for: indexPath) as! SubcategoryCell
        let section = catalogElement[indexPath.section]
        cell.subcategoryLabel.text = section.items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = catalogElement[indexPath.section].items
        let vc = DetailViewController()
        vc.entry.text = detail[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
