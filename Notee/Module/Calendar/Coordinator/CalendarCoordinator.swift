//
//  CalendarCoordinator.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 15/07/2021.
//

import UIKit

class CalendarCoordinator: BaseCoordinator {
    override func start(){
        let vc = CalendarVC()
        vc.viewModel = CalendarVM(CalendarService(), self)
        navigation = BaseNavigationViewController(rootViewController: vc)
    }
}

extension CalendarCoordinator{
    func showTask(taskObj: TaskObj? = nil){
        let coordinator = TaskCoordinator(navigation, taskObj)
        coordinate(to: coordinator)
    }
}
