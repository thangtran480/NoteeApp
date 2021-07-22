//
//  AppCoordinator.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 15/07/2021.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    var window: UIWindow?
    
    init(window: UIWindow?){
        self.window = window
        super.init()
    }
    
    override func start() {
        startCalendar()
    }
    private func startLogin(){
        
    }
    private func startCalendar(){
        let vc = CalendarCoordinator(self.navigation)
        coordinate(to: vc)
        
        window?.rootViewController = vc.navigation
        window?.makeKeyAndVisible()
    }
}
