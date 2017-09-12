//
//  PaymentController.swift
//  StripeTutorial
//
//  Created by Stephen Bodnar on 11/09/2017.
//
//

import Foundation
import Vapor

final class PaymentController {
    let droplet: Droplet
    let view:ViewRenderer
    let stripeConfig: StripeConfiguration
    
    init(drop: Droplet, view: ViewRenderer, stripeConfig: StripeConfiguration) {
        self.droplet = drop
        self.view = view
        self.stripeConfig = stripeConfig
    }
    
    func addRoutes() {
        droplet.get("pay", handler: showPaymentPage)
        droplet.post("pay", handler: pay)
    }
    
    func showPaymentPage(request: Request) throws -> ResponseRepresentable {
        return try view.make("payments/pay", ["publishableKey": stripeConfig.publishableKey], for: request)
    }
    
    func pay(request: Request) throws -> ResponseRepresentable {
        if let token = request.data["stripeToken"]?.string {
            return try Response.async { responder in
                StripeAPIManager.chargeCard(withAmount: 999, withDescription: "first charge!", fromSourceToken: token, andConfig: self.stripeConfig, completion: { (completed, errorMessage) in
                    if errorMessage == "" {
                        responder.close(with: "success!")
                    } else { responder.close(with: errorMessage) }
                })
            }
        } else { return "no token in params" }
    }
}
