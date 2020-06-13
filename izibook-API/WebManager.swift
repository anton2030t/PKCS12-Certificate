//
//  WebManager.swift
//  izibook-API
//
//  Created by Anton Larchenko on 10.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation
import UIKit

class WebManager {
    
    private let certificateURL = "https://authan-test.izibook.ru:13302/api/anonymous"
    private let catalogURL = "https://rest-test.izibook.ru:10001/api/globcat/list"
    
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let certificateModel = try JSONDecoder().decode(CertificateModel.self, from: data)
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
                                 delegate: URLSessionPinningDelegate(),
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
    
    func loadImage(imageId: String, height: String, width: String, completion: @escaping ([ImageModel])->()) {
        guard let url = URL(string: imageURL(imageId: imageId, height: height, width: width)) else { return }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                 delegate: URLSessionPinningDelegate(),
                                 delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("ru-RU", forHTTPHeaderField: "x-lang")
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
//            let images = ImageModel(image: UIImage(data: data)!)
//            completion([images])
            
        }.resume()
    }
    
}



class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let pkcs12 = "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"
        let p12Data = Data(base64Encoded: pkcs12)
        
        let sertData = PKCS12(PKCS12Data: p12Data! as NSData)
        let credential = URLCredential(PKCS12: sertData)
        
        completionHandler(.useCredential, credential)
    }
    
}
