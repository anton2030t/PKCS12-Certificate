//
//  PKCS12.swift
//  izibook-API
//
//  Created by Anton Larchenko on 11.06.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

public final class PKCS12 {
    
    let label:String?
    let keyID:NSData?
    let trust:SecTrust?
    let certChain:[SecTrust]?
    let identity:SecIdentity?
    
    public init(PKCS12Data: NSData) {
        
        let importPasswordOption: NSDictionary = [kSecImportExportPassphrase: ""]
        var items: CFArray?
        let secError: OSStatus = SecPKCS12Import(PKCS12Data, importPasswordOption, &items)
        
        guard secError == errSecSuccess else {
            if secError == errSecAuthFailed {
                NSLog("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            }
            fatalError("SecPKCS12Import returned an error trying to import PKCS12 data.\n\(String(describing: SecCopyErrorMessageString(secError, nil)))")
        }
        
        guard let theItemsCFArray = items else { fatalError()  }
        let theItemsNSArray: NSArray = theItemsCFArray as NSArray
        
        guard let dictArray = theItemsNSArray as? [[String:AnyObject]] else { fatalError() }
        func f<T>(key:CFString) -> T? {
            for d in dictArray {
                if let v = d[key as String] as? T {
                    return v
                }
            }
            return nil
        }
        
        self.label = f(key: kSecImportItemLabel)
        self.keyID = f(key: kSecImportItemKeyID)
        self.trust = f(key: kSecImportItemTrust)
        self.certChain = f(key: kSecImportItemCertChain)
        self.identity =  f(key: kSecImportItemIdentity)
    }
}

public extension URLCredential {
    convenience init?(PKCS12: PKCS12) {
        if let identity = PKCS12.identity {
            self.init(
                identity: identity,
                certificates: PKCS12.certChain,
                persistence: URLCredential.Persistence.forSession)
        }
        else { return nil }
    }
}
