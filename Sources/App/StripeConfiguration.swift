//
//  StripeConfiguration.swift
//  StripeTutorial
//
//  Created by Stephen Bodnar on 11/09/2017.
//
//

import Foundation
import Vapor

final class StripeConfiguration: ConfigInitializable {
    let publishableKey: String
    let secretKey: String
    
    init(publishableKey: String, secretKey: String) {
        self.publishableKey = publishableKey
        self.secretKey = secretKey
    }
    
    convenience init(config: Config) throws {
        let pubKey = config["stripe", "publishableKey"]?.string ?? ""
        let secKey = config["stripe", "secretKey"]?.string ?? ""
        self.init(publishableKey: pubKey, secretKey: secKey)
    }
}
