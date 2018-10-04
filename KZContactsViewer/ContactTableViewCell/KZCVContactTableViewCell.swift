//
//  KZCVContactTableViewCEllTableViewCell.swift
//  KZContactsViewer
//
//  Created by Kai Zou on 10/2/18.
//  Copyright © 2018 Kai Zou. All rights reserved.
//

import UIKit

class KZCVContactTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introductionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFirstName(_ firstName: String, lastName: String) {
        let attribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0) ]
        let fullName = NSMutableAttributedString(string: firstName, attributes: attribute )
        
        let attributedLastName = NSAttributedString(string: String(format: " %@", lastName))
        fullName.append(attributedLastName)
        
        let lastNameRange = NSRange(location: firstName.count + 1, length: lastName.count)
        fullName.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17.0, weight: .thin), range: lastNameRange)
        
        self.nameLabel.attributedText = fullName
    }
    
}
