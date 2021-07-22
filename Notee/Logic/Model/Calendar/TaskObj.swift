//
//  TaskObj.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 16/07/2021.
//

import Realm
import RealmSwift


@objcMembers class TaskObj: Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var title = ""
    @objc dynamic var created = Date()
    @objc dynamic var updated = Date()
    @objc dynamic var remindDate: Date?
    @objc dynamic var dueDate =  Date()
    @objc dynamic var isRepeat = false
    @objc dynamic var location = ""
    @objc dynamic var note = ""
    @objc dynamic var label = ""
    @objc dynamic var isComplete = false
    @objc dynamic var isStar = false
    
    convenience init(title: String, note: String, label: String, isRepeat: Bool, location: String, isComponent: Bool, remindDate: Date?, dueDate: Date, isStar: Bool){
        self.init()
        
        self.id = UUID.init().uuidString
        self.title = title
        self.note = note
        self.label = label
        self.isComplete = false
        self.created = Date()
        self.isRepeat = isRepeat
        self.updated = Date()
        self.location = location
        self.remindDate = remindDate
        self.dueDate = dueDate
        self.isStar = isStar
    }
    func updateTaskObj(taskObj: TaskObj) {
        try! realm?.write(){
            self.title = taskObj.title
            self.note = taskObj.note
            self.label = taskObj.label
            self.isComplete = taskObj.isComplete
            self.isRepeat = taskObj.isRepeat
            self.updated = Date()
            self.location = taskObj.location
            self.remindDate = taskObj.remindDate
            self.dueDate = taskObj.dueDate
//            self.isStar = taskObj.isStar
        }
    }
    func updateIsStar(_ isStar: Bool){
        try! realm?.write{
            self.isStar = isStar
        }
    }
    func updateIsComplete(_ isComplete: Bool){
        try! realm?.write{
            self.isComplete = isComplete
        }
    }
}
