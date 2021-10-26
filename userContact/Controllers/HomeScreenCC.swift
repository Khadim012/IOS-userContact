//
//  HomeScreenCC.swift
//  userContact
//
//  Created by Khadim Hussain on 25/10/2021.
//

import UIKit
import SDWebImage

class HomeScreenCC: UITableViewCell {

    @IBOutlet weak var lblAlphabet: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSid: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    
    @IBOutlet weak var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        imgUser.layer.borderWidth = 1.0
        imgUser.layer.borderColor = Constants.appColor.redCustom.cgColor
    }

    func configContactCell(model: contactData) {
        
        lblSid.text = model.username ?? ""
        lblUserName.text = model.sid ?? ""
        imgUser.sd_setImage(with: URL(string: model.profile_image_url ?? "") , placeholderImage: UIImage(named: "testUser"))
    }
}
