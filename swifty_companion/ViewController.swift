//
//  ViewController.swift
//  swifty_companion
//
//  Created by Mpho MAHLOKO on 2020/01/08.
//  Copyright © 2020 Mpho MAHLOKO. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate{
    
    var b = "null";
    let CUSTOMER_KEY = ""
    let CUSTOMER_SECRET = ""
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchUser(_ sender: UIButton) {
        makeIntraRequest(requestBody: searchField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        justget()
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        if let newUrl = URLComponents(string: url) {
            return newUrl.queryItems?.first(where: { $0.name == param })?.value
        }
        else {
            return (nil)
        }
    }
    
    func makeIntraRequest(requestBody: String) {
            let urlGetUserInfo = "https://api.intra.42.fr/v2/users/" + requestBody
            var request: NSMutableURLRequest?
            if let urlForAPI = NSURL(string: urlGetUserInfo) {
                request = NSMutableURLRequest(url: urlForAPI as URL)
                request?.httpMethod = "GET"
                
                request?.setValue("Bearer " + self.b, forHTTPHeaderField: "Authorization")
            }
            else {
                return
            }
            let task = URLSession.shared.dataTask(with: request! as URLRequest) { (data, response, error) in
                if error != nil {
                    print("an error has occured")
                } else if let userData = data {
                    do {
                        if let dic : NSDictionary = try JSONSerialization.jsonObject(with: userData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print(dic)
//                            if let projects = dic["projects_users"] {
//                                    print(projects)
//                            }
//                            else {
//                                print("could not access data")
//                            }
                        }
                    }
                    catch (let err) {
                       print(err)
                    }
                }
            }
            task.resume()
        }
    
   func justget() {
            let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8, allowLossyConversion: true)?.base64EncodedString(options: NSData.Base64EncodingOptions (rawValue: 0)))
            let url_tokens = "https://api.intra.42.fr/oauth/token"
            let url_k = NSURL(string: url_tokens)!
            let request = NSMutableURLRequest(url: url_k as URL)
            request.httpMethod = "POST"
            request.setValue("Basic " + BEARER!, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8, allowLossyConversion: false)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                }
                else if let d = data {
                        do {
                            if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            self.b = (dic.object(forKey: "access_token") as? String)!
                        }
                    }
                    catch (let err) {
                        print(err)
                    }
                }
            }
            task.resume()
        }
}
