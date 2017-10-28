//
//  skillsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Emmanuelle TERMEAU on 10/26/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit

class skillsTableViewCell: UITableViewCell {

    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var skillLabel: UILabel!
    
    
    
    var skill : (String, String)? {
        didSet {
            if let s = skill {
                levelLabel?.text = String(s.1)
                skillLabel?.text = s.0
            }
        }
    }

}
