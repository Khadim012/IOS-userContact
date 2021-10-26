//
//  HomeScreenVC.swift
//  userContact
//
//  Created by Khadim Hussain on 25/10/2021.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak fileprivate var homeScreenView: HomeScreenView!
    
    var isSearching = false
    var lastValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeScreenView.setupUI()
        self.homeScreenView.registerCell()
        self.homeScreenView.setHeaderView()
        
        //For Search
        self.homeScreenView.txtSearch.delegate = self
        self.homeScreenView.txtSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.homeScreenView.performWSToGetContactList()
    }
    
    @IBAction func didTapContactType(_ sender: UIButton) {
        
        self.homeScreenView.selectedType(sender: sender)
    }
}

// MARK:- UITableView Delegates & DataSource
extension HomeScreenVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Checking for search
        if self.isSearching {
            
            if let contactList = self.homeScreenView.arrSearchContact {
                
                return contactList.count
            }
        }
        else {
            
            if let contactList = self.homeScreenView.arrContactList {
                
                return contactList.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        // We can make it dynaimic but i use static according to the data
        return 82
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCC") as? HomeScreenCC {
            
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(didTapAddRemove), for: .touchUpInside)
            
            //Checking for search
            if self.isSearching {
                
                if let contactList = self.homeScreenView.arrSearchContact {
                    
                    let contact = contactList[indexPath.row]
                    cell.configContactCell(model: contact)
                    
                    cell.imgCheck.image = self.homeScreenView.arrSelectedContacts.contains(contact.sid ?? "") ? UIImage(named: "select") :  UIImage(named: "unselect")
                    
                    if contact.username != "" {
                        
                        let text = contact.username ?? ""
                        let prefixValue = String(text.prefix(1))
                        
                        if prefixValue.lowercased() != lastValue.lowercased() {
                            
                            
                            lastValue = prefixValue
                            cell.lblAlphabet.text = prefixValue.capitalized
                            
                        }
                        else {
                            
                            cell.lblAlphabet.text = ""
                        }
                    }
                }
            }
            else {
                
                if let contactList = self.homeScreenView.arrContactList {
                    
                    let contact = contactList[indexPath.row]
                    cell.configContactCell(model: contact)
                    
                    cell.imgCheck.image = self.homeScreenView.arrSelectedContacts.contains(contact.sid ?? "") ? UIImage(named: "select") :  UIImage(named: "unselect")
                    
                    if contact.username != "" {
                        
                        let text = contact.username ?? ""
                        let prefixValue = String(text.prefix(1))
                        
                        if prefixValue.lowercased() != lastValue.lowercased() {
                            
                            
                            lastValue = prefixValue
                            cell.lblAlphabet.text = prefixValue.capitalized
                            
                        }
                        else {
                            
                            cell.lblAlphabet.text = ""
                        }
                    }
                }
            }
            
           
            return cell
        }

        return UITableViewCell()
    }

    @objc func didTapAddRemove(sender: UIButton) {
        
        let row = sender.tag
        let indexPath = IndexPath(item: row, section: 0)
  
        var contact: contactData?
        
        //Checking for search
        if self.isSearching {
            
            contact = self.homeScreenView.arrSearchContact?[indexPath.row]
        }
        else {
            
            contact = self.homeScreenView.arrContactList?[indexPath.row]
        }
        let cell = self.homeScreenView.tbContact.cellForRow(at: indexPath) as? HomeScreenCC
    
        if self.homeScreenView.arrSelectedContacts.contains(contact?.sid ?? "") {
            
            if let index = self.homeScreenView.arrSelectedContacts.firstIndex(where: { $0 == contact?.sid ?? "" }) {
            
                self.homeScreenView.arrSelectedContacts.remove(at: index)
                self.homeScreenView.arrSelectedContactList?.remove(at: index)
                cell?.imgCheck.image = UIImage(named: "unselect")
            }
        }
        else {
        
            if self.homeScreenView.arrSelectedContactList?.count == nil {
                
                self.homeScreenView.arrSelectedContactList = [contactData]()
            }
            self.homeScreenView.arrSelectedContactList?.append(contact!)
            
            self.homeScreenView.arrSelectedContacts.append(contact?.sid ?? "")
            cell?.imgCheck.image = UIImage(named: "select")
        }
        self.homeScreenView.setHeaderView()
    }
}

//MARK: - CollectionView Delegates and dataSources
extension HomeScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.homeScreenView.arrSelectedContactList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenClv", for: indexPath) as! HomeScreenClv
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        if let contactList = self.homeScreenView.arrSelectedContactList {
            
            let contact = contactList[indexPath.row]
            cell.configContactCell(model: contact)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: collectionView.frame.size.height - 40, height: collectionView.frame.size.height)
    }
    
    @objc func didTapRemove(sender: UIButton) {
        
        let row = sender.tag
        let indexPath = IndexPath(item: row, section: 0)
        let contact = self.homeScreenView.arrSelectedContactList?[indexPath.row]
     
        if self.homeScreenView.arrSelectedContacts.contains(contact?.sid ?? "") {
            
            if let index = self.homeScreenView.arrSelectedContacts.firstIndex(where: { $0 == contact?.sid ?? "" }) {
            
                self.homeScreenView.arrSelectedContacts.remove(at: index)
                self.homeScreenView.arrSelectedContactList?.remove(at: index)
            }
        }
        self.homeScreenView.setHeaderView()
    }
}

//MARK:- TextField delagtes and search
extension HomeScreenVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField) {
   
        if let searchText = textField.text, !(searchText.isEmpty) {

            if let contactList = self.homeScreenView.arrContactList {
        
                self.homeScreenView.arrSearchContact = contactList.filter{($0.username?.prefix(searchText.count) ?? "") == searchText.lowercased() }
                self.isSearching = true
                self.homeScreenView.tbContact.reloadData()
            }
            
        }
        else {
            
            isSearching = false
            self.homeScreenView.tbContact.reloadData()
        }
    }
}
