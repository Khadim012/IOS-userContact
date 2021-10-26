//
//  HomeScreenClv.swift
//  userContact
//
//  Created by Khadim Hussain on 26/10/2021.
//

import UIKit

class HomeScreenClv: UICollectionViewCell {
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgRemove: UIImageView!
    
    @IBOutlet weak var btnRemove: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        imgUser.layer.borderWidth = 1.0
        imgUser.layer.borderColor = Constants.appColor.redCustom.cgColor
    }

    func configContactCell(model: contactData) {
    
        lblUserName.text = model.username ?? ""
        imgUser.sd_setImage(with: URL(string: model.profile_image_url ?? "") , placeholderImage: UIImage(named: "testUser"))
    }
}
