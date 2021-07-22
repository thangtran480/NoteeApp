//
//  TaskCoordinator.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 19/07/2021.
//

import UIKit

class TaskCoordinator: BaseCoordinator{
    var taskObj : TaskObj?
    init(_ navigationController: UINavigationController = BaseNavigationViewController(), _ taskObj: TaskObj?) {
        super.init(navigationController)
        self.taskObj = taskObj
    }
    
    override func start() {
        let vc = TaskVC()
        if let task = self.taskObj{
            vc.viewModel = TaskVM(service: TaskService(), coordinator: self, taskObj: task)
        }else{
            vc.viewModel = TaskVM(service: TaskService(), coordinator: self)
        }
        
        self.navigation.pushViewController(vc, animated: true)
    }
}

extension TaskCoordinator{
    
    func backToCalendar(){
        self.navigation.popViewController(animated: true)
    }
}
