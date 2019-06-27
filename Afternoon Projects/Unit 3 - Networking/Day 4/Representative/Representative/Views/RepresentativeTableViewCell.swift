//
//  RepresentativeTableViewCell.swift
//  Representative
//
//  Created by Drew Seeholzer on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class RepresentativeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var representative: Representative? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let rep = representative else {return}
        nameLabel.text = rep.name
        partyLabel.text = rep.party
        districtLabel.text = rep.district
        websiteLabel.text = rep.link
        phoneLabel.text = rep.phone
        
    }
    
}
