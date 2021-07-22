//
//  TaskService.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 19/07/2021.
//

import RealmSwift

class TaskService: BaseRealmService {
    var realm: Realm
    
    override init() {
        self.realm = try! Realm()
    }
    func addTask(_ task: TaskObj){
        try! realm.write{
            realm.add(task)
        }
    }
}
