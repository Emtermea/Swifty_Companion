//
//  UserViewController.swift
//  SwiftyCompanion
//
//  Created by Emmanuelle TERMEAU on 10/23/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit
import Foundation

import SwiftyJSON
import Alamofire


class UserViewController: UIViewController, UIScrollViewDelegate , UITableViewDataSource, UITableViewDelegate {

    var imageView : UIImageView?
    var image : UIImage?
    
    var response : JSON = [] {
        didSet {
            
        }
    }
    
    var data : [(name: String, mark: Any )] = []
    
    var dataSkills : [(skill: String, level: String)] = []

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!


    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self 
        }
    }
    
    @IBOutlet weak var skillTableView: UITableView! {
        didSet {
            skillTableView.delegate = self
            skillTableView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayUserInfo()
        buildDBProject()
        buildDBSkills()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildDBSkills () {
        var skill : String?
        var level : String?
        
        let skills = self.response["cursus_users"][0]["skills"]
        for (_, json) in skills {
            skill = json["name"].string
            level = String(format: "%.2f",json["level"].float!)
            self.dataSkills.append((skill: skill!, level: level!))
        }
//        print(self.dataSkills)
    }
    
    func buildDBProject () {
        var name : String?
        var mark : Any?
        
        let project = self.response["projects_users"]
//        print (project)
        for (_, json) in project {
            name = json["project"]["slug"].string
            if json["status"].string == "in_progress" {
                mark = json["status"].string
            } else {
                mark = json["final_mark"].stringValue
            }
            self.data.append((name: name!, mark : mark!))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if tableView == self.tableView {
            count = self.data.count
        }
        if tableView == self.skillTableView {
            count = self.dataSkills.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as? ProjectTableViewCell {
                cell.project = self.data[indexPath.row]
                return cell
            }
        }
        if tableView == self.skillTableView {
            if let cell = skillTableView.dequeueReusableCell(withIdentifier: "skillsCell") as? skillsTableViewCell {
                cell.skill = self.dataSkills[indexPath.row]
                return cell
            }
        }
        return ProjectTableViewCell()
    }
    
    func DisplayUserInfo() {
        displayImg()
        displayLogin()
        displayName()
        displayOthers()
        displayLevel()
        
    }

    func displayImg () {
        
        let defaultHeight : CGFloat = 144.0
        let defaultWidth : CGFloat = 120.0
        
        if let imageUrl = URL(string : self.response["image_url"].stringValue) {
            if let data = try? Data(contentsOf: imageUrl) {
                image = UIImage(data: data)
            }
        }
        imageView = UIImageView(image: image)
        infoView.addSubview(imageView!)
        imageView?.frame.size.height = (imageView?.frame.size.height)! * 0.6
        imageView?.frame.size.width = (imageView?.frame.size.width)! * 0.6
        if (imageView?.frame.size.width)! > defaultWidth || (imageView?.frame.size.height)! > defaultHeight {
            imageView?.frame.size.width = defaultWidth
            imageView?.frame.size.height = defaultHeight
            print("Use default CGFloat")
        }
    }
    
    func displayLogin () {
        let login = self.response["cursus_users"][0]["user"]["login"].string
        if login != "" {
            loginLabel.text = login
        }
    }
    
    func displayName() {
        let name = String(self.response["displayname"].stringValue)
        if name != "" {
            nameLabel.text = name
        } else {
            nameLabel.text = ""
        }
    }
    
    func displayOthers() {
        if let mail = String(self.response["email"].stringValue) {
            mailLabel.text = mail
        }
        if let phone = String(self.response["phone"].stringValue) {
            phoneLabel.text = phone
        }
        let location = String(self.response["location"].stringValue)
        if location != "" {
            locationLabel.text = location
        } else {
            locationLabel.text = "Unavailable"
        }
        
    }
    
    func displayLevel () {
        
        let level = self.response["cursus_users"][0]["level"]
        if level != "" {
            levelLabel.text = "Level " + String(describing: level) + " %"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
