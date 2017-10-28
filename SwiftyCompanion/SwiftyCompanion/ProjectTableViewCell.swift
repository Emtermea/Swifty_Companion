//
//  ProjectTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Emmanuelle TERMEAU on 10/25/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    
    var project : (String, Any)? {
        didSet {
            if let p = project {
                noteLabel?.text = String(describing: p.1)
                projectNameLabel?.text = p.0
            }
        }
    }
    
/*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 */

}
