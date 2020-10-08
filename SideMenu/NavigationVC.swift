//
//  NavigationVC.swift
//  Pay Invoice Supplier
//
//  Created by Rohini Deo on 24/07/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import UIKit

class NavigationVC: ENSideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: SideMenuVC(), menuPosition:.left)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = self.view.bounds.width * 0.7
        sideMenu?.bouncingEnabled = false
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NavigationVC: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        
    }
    
    func sideMenuWillClose() {
       
    }
    
    func sideMenuDidClose() {
        
    }
    
    func sideMenuDidOpen() {
       
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
}

