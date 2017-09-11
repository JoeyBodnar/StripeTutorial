import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("description") { req in return req.description }
        
        let stripeConfig = try StripeConfiguration(config: self.config)
        let paymentsController = PaymentController(drop: self, view: self.view, stripeConfig: stripeConfig)
        paymentsController.addRoutes()
        
    }
}
