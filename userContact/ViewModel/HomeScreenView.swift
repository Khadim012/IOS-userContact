//
//  HomeScreenView.swift
//  userContact
//
//  Created by Khadim Hussain on 25/10/2021.
//

import UIKit

class HomeScreenView: UIView {

    @IBOutlet weak var tbContact: UITableView!
    @IBOutlet weak var clvContact: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewNextButton: UIView!
    
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    
    var arrContactList: [contactData]?
    var arrSearchContact: [contactData]?
    var arrSelectedContactList: [contactData]?
    var arrSelectedContacts = [String]()
    
    func setupUI() {
        
        viewNextButton.addBottomRightShadow()
    }
    
    func registerCell() {

        clvContact.register(UINib(nibName: "HomeScreenClv", bundle: nil), forCellWithReuseIdentifier: "HomeScreenClv")
        tbContact.register(UINib(nibName: "HomeScreenCC", bundle: nil), forCellReuseIdentifier: "HomeScreenCC")
    }
    
    func setHeaderView() {
        
        if let arr = self.arrSelectedContactList , arr.count > 0 {
            
            self.collectionViewHeight.constant = 123
            self.tbContact.tableHeaderView?.frame.size = CGSize(width: self.tbContact.frame.width, height: CGFloat(344))

        }
        else {
            
            self.collectionViewHeight.constant = 0
            self.tbContact.tableHeaderView?.frame.size = CGSize(width: self.tbContact.frame.width, height: CGFloat(221))
            
        }
        
        self.layoutIfNeeded()
        self.tbContact.layoutIfNeeded()
        self.clvContact.layoutIfNeeded()
        UIView.transition(with: self.clvContact, duration: 0.35, options: .transitionCrossDissolve,animations: { self.clvContact.reloadData() })
        UIView.transition(with: self.tbContact, duration: 0.35, options: .transitionCrossDissolve,animations: { self.tbContact.reloadData() })
    }
    
    func selectedType(sender: UIButton) {
        
        if sender.tag == 0 {
            
            self.viewUser.isHidden = true
            UIView.transition(with: self.viewContact, duration: 0.35, options: .transitionCrossDissolve,animations: { self.viewContact.isHidden = false }){ (finished) in
                self.lblUser.textColor = .black
                self.lblContact.textColor = Constants.appColor.redCustom
            }
        }
        else {
            
            self.viewContact.isHidden = true
            UIView.transition(with: self.viewUser, duration: 0.35, options: .transitionCrossDissolve,animations: { self.viewUser.isHidden = false }){ (finished) in
                self.lblContact.textColor = .black
                self.lblUser.textColor = Constants.appColor.redCustom
            }
        }
    }
    
}

//MARK:- WebServices
extension HomeScreenView {
    
    func performWSToGetContactList() {
       
        WebServices.URLResponse("user/?fields=sid,username,-_id,profile_image_url", method: .get, parameters: nil, headers: nil, withSuccess: { (response) in
            
            do{
                let FULLResponse = try
                    JSONDecoder().decode(userContact.self, from: response)
    
                self.arrContactList = FULLResponse.sorted(by: { (Obj1, Obj2) -> Bool in
                      let Obj1_Name = Obj1.username ?? ""
                      let Obj2_Name = Obj2.username ?? ""
                      return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                   })
                
                
                self.tbContact.reloadData()
                self.clvContact.reloadData()
                
            }catch let jsonerror{
                
                print("error parsing json objects",jsonerror)
            }
        }){ (error) in
        }
    }
}
