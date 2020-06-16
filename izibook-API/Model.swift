//
//  Model.swift
//  izibook-API
//
//  Created by Anton Larchenko on 10.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import UIKit

//
struct CertificateModel: Codable {
    var result: String
    var data: CertificateData
}

struct CertificateData: Codable {
    var publicData: String
    var privateData: String
    var expire: String
    var pkcs12: String
    
    enum CodingKeys: String, CodingKey {
        case publicData = "public"
        case privateData = "private"
        case expire = "expire"
        case pkcs12 = "pkcs12"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        publicData = try container.decode(String.self, forKey: .publicData)
        privateData = try container.decode(String.self, forKey: .privateData)
        expire = try container.decode(String.self, forKey: .expire)
        pkcs12 = try container.decode(String.self, forKey: .pkcs12)
    }
    
}


//
struct CatalogModel: Codable {
    var data: [CatalogElement]
    var result: String
    var results: Int
}

struct CatalogElement: Codable {
    var popularity: Bool
    var icon: String
    var title: String
    var id: Int
    var items: [CatalogItem]
}

struct CatalogItem: Codable {
    var id: Int
    var title: String
}


//
struct ImageModel {
    var image: UIImage
}
