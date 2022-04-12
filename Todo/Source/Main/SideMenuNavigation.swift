//
//  SideMenuNavigation.swift
//  Todo
//
//  Created by 김지훈 on 2022/03/10.
//

import UIKit
import SideMenu

class SideMenuNavigation: SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presentationStyle = .menuSlideIn
        
        self.presentationStyle.onTopShadowOpacity = 1
        self.menuWidth = self.view.frame.width * 0.7
        self.presentDuration = 0.5
        self.dismissDuration = 0.5
    }
    
}
