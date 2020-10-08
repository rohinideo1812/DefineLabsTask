//
//  SavedMatchesVC.swift
//  Task
//
//  Created by Rohini Deo on 07/10/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import UIKit

class SavedMatchesVC: UIViewController {
    
    //Mark:IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    //Mark:Properties:
    var matchData = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved Matches"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle.grid.3x3.fill"), style: .plain, target: self, action: #selector(handleSelectBtn(gestureRecognizer:)))
        
        //Mark:Register tableview cell
        self.tableView.register(UINib(nibName:"TableViewCell", bundle: nil), forCellReuseIdentifier:"TableViewCell")
        
        self.matchData = DataBaseHelper.shareInstance.getAllData()
    }
    
    @objc private func handleSelectBtn(gestureRecognizer: UIGestureRecognizer) {
        toggleSideMenuView()
    }
}

extension SavedMatchesVC : ENSideMenuDelegate,UITableViewDelegate,UITableViewDataSource{
    func sideMenuWillOpen() {
        
    }
    
    func sideMenuWillClose() {
        
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func sideMenuDidOpen() {
        
    }
    
    func sideMenuDidClose() {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.name.text = self.matchData[indexPath.row].name
        cell.id.text = self.matchData[indexPath.row].id
        cell.address.text = self.matchData[indexPath.row].address
        cell.contact.text = self.matchData[indexPath.row].phone
        cell.country.text = self.matchData[indexPath.row].country
        cell.saveBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.saveBtn.tag = indexPath.row
        cell.saveBtn.addTarget(self, action: #selector(self.handleSavebtn(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchData.count
    }
    
    @objc  func handleSavebtn(_ sender:UIButton) {
        self.matchData = DataBaseHelper.shareInstance.deleteMatchData(index: sender.tag)
        self.tableView.reloadData()
    }
}
