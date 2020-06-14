//
//  WebManager.swift
//  izibook-API
//
//  Created by Anton Larchenko on 10.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import UIKit

class WebManager: NSObject {
    
    private let certificateURL = "https://authan-test.izibook.ru:13302/api/anonymous"
    private let catalogURL = "https://rest-test.izibook.ru:10001/api/globcat/list"
    
    private var certificate: CertificateData?

    private let json: [String: Any] = [
        "filter": ["parent": 1],
        "view": [
            ["code": "icon"],
            ["code": "id"],
            ["code": "title"],
            ["code": "popularity"],
            ["code": "items",
             "view": [
                ["code": "id"],
                ["code": "title"],
                ["code": "items",
                 "view": [
                    ["code": "id"],
                    ["code": "title"]
                    ]
                ]
                ]
            ]
        ]
    ]
    
    func getCertificate(completion: @escaping (CertificateModel?)->()) {
        
        var request = URLRequest(url: URL(string: certificateURL)!)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let certificateModel = try JSONDecoder().decode(CertificateModel.self, from: data)
                self?.certificate = certificateModel.data

                completion(certificateModel)
                print(certificateModel)
            } catch let error {
                completion(nil)
                
                let alert = UIAlertController(title: "Нет связи с сервером", message: "Попробуйте снова", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default))
                
                print(error)
            }
            
        }.resume()
    }
    
    func getCatalog(completion: @escaping (CatalogModel?)->()) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                 delegate: self,
                                 delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: URL(string: catalogURL)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("ru-RU", forHTTPHeaderField: "x-lang")
        
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let catalogModel = try JSONDecoder().decode(CatalogModel.self, from: data)
                completion(catalogModel)
                print(catalogModel)
            } catch let error {
                completion(nil)
                
                let alert = UIAlertController(title: "Нет связи с сервером", message: "Попробуйте снова", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default))
                
                print(error)
            }
            
        }.resume()
    }
    
    
    func imageURL(imageId: String, height: String, width: String) -> String {
        return "http://mi-test.izibook.ru/imagemanager/manager/singleget?&image=\(imageId)&h=\(height)&w=\(width)"
    }
    
    func loadImage(imageId: String, height: String, width: String, completion: @escaping (ImageModel)->()) {
        guard let url = URL(string: imageURL(imageId: imageId, height: height, width: width)) else { return }
                
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                 delegate: self,
                                 delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("ru-RU", forHTTPHeaderField: "x-lang")
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let images = ImageModel(image: UIImage(data: data)!)
            completion(images)
            
        }.resume()
    }
    
}



extension WebManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let certificate = certificate else { return }
        let p12Data = Data(base64Encoded: certificate.pkcs12)
        
        let sertData = PKCS12(PKCS12Data: p12Data! as NSData)
        let credential = URLCredential(PKCS12: sertData)
        
        completionHandler(.useCredential, credential)
    }
    
}
