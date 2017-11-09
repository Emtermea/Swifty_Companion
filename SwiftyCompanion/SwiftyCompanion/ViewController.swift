//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Emmanuelle TERMEAU on 10/17/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit
import Foundation

import SwiftyJSON

import Alamofire


let myUID = "931dafeb6637c681b39097b54bdf07fba0c1416cc1dfe3d523b888260733311e"
let mySECRET = "f5ede0c4bfaead3ba5d4436edbd9c13c2e94ca72596dbde97f41540c1b27ad50"



class ViewController: UIViewController {

    var token : (token : String , expire: Int)? {
        didSet {
        }
    }
    
    var response : JSON = [] {
        didSet {
            performSegue(withIdentifier: "SegueID", sender: "")
        }
    }
    
    var click : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallPaperSwifty.jpg")!)
        loginField.autocorrectionType = .no
        getToken()
    }

    func getToken() {
        print("********************* getToken() ***********************")
        let url = URL(string: "https://api.intra.42.fr/oauth/token?grant_type=client_credentials&client_id=\(myUID)&client_secret=\(mySECRET)")
         Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseData) -> Void in
            if ((responseData.result.value) != nil) {
                let result = JSON(responseData.result.value!)
                print (result)
                
                self.token = (result["access_token"].stringValue,result["expires_in"].intValue)
                print (" expiration token 2 : \(String(describing: self.token!.expire))")
                let exp = self.token?.expire
                print("------------------ expire token  ---------------- \(exp ?? 1000))")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var loginField: UITextField!
    
    @IBAction func submitLogin(_ sender: Any) {
        self.click = true
        if  let searchUsr = loginField.text {
            if searchUsr.isEmpty {
                return
            }

            if (token?.expire)! < 10 {
                displayAlert(code: -1)
                return
            }
            let header : HTTPHeaders = [
                "Authorization": "Bearer \(token?.token ?? "toto")"
                ]
            Alamofire.request("https://api.intra.42.fr/v2/users/\(searchUsr)", headers: header).responseJSON { (responseData) -> Void in
                if (responseData.result.isSuccess) {
                    if ((responseData.result.value) != nil) {
                        if JSON(responseData.result.value!).isEmpty {
                            self.displayAlert(code: 2)
                                return
                        }
                        if self.click {
                            self.click = false
                            self.response = JSON(responseData.result.value!)
                        }
                    } else {
                        print(responseData.result)
                        self.displayAlert(code: 1)
                    }
                } else {
                    self.displayAlert(code: 1)
                }
            }
        }
    }
    
    func displayAlert (code : Int) {
        let title = "Alert !"
        var message : String?
        if code > 0 {
            if code == 1 {
                message = "An error has occurred"
            }
            if code == 2 {
                message = "Invalid login user"
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if code == -1 {
                message = "Your access has almost expired"
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ask new access token", style: UIAlertActionStyle.default, handler: { action in
                    self.getToken()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
   // ovveride de la function prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueID" {
            let user = segue.destination as! UserViewController
            user.response = self.response
            }
        }
    }


