//
//  DetailViewController.swift
//  izibook-API
//
//  Created by Anton Larchenko on 13.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    let entry: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 15)
        view.isEditable = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entry.isScrollEnabled = false
        view.addSubview(entry)
        setupEntry()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        entry.isScrollEnabled = true
    }
    
    func setupEntry() {
        entry.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        entry.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        entry.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        entry.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
