//
//  StripeAPIManager.swift
//  StripeTutorial
//
//  Created by Stephen Bodnar on 11/09/2017.
//
//

import Foundation

class StripeAPIManager {
    static let chargesUrl = "https://api.stripe.com/v1/charges" // (1)
    
    class func chargeCard(withAmount amount: Int, withDescription descr: String, fromSourceToken token: String, andConfig stripeConfig: StripeConfiguration, completion: @escaping (_ completed: Bool, _ errorMessage: String) -> Void) {
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: StripeAPIManager.chargesUrl)!)
        
        // (2)
        let myParams = "amount=\(amount)&currency=usd&description=\(descr)&source=\(token)"
        let postData = myParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
        request.httpBody = postData
        request.httpMethod = "POST"
        
        // (3)
        let postLength = String(format: "%d", postData!.count)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // (4)
        let authBearer = "Bearer " + stripeConfig.secretKey
        request.setValue(authBearer, forHTTPHeaderField: "Authorization")
        
        // (5)
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(json)
                if let dict = json as? NSDictionary, let stripeError = dict["error"] as? NSDictionary, let errorMessage = stripeError["message"] as? String {
                    completion(false, errorMessage)
                } else {
                    completion(true, "")
                }
            }catch { completion(false, "Could not serialize JSON") }
        }
        task.resume()
    }
}
