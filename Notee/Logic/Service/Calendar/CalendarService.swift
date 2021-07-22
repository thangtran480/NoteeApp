//
//  CalendarService.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 16/07/2021.
//

import RealmSwift

class CalendarService: BaseRealmService {
    var realm: Realm
    
    override init() {
        self.realm = try! Realm()
    }

    func deleteTask(_ task: TaskObj){
        try! realm.write(){
            realm.delete(task)
        }
    }
    func getAllTask() -> Results<TaskObj>{
        return realm.objects(TaskObj.self).sorted(byKeyPath: "created")
    }
    func getAllTaskByDate(_ date: Date) -> Results<TaskObj>{
        return realm.objects(TaskObj.self).filter("dueDate >= %@ AND dueDate <= %@", date, self.getEndTime(from: date)).sorted(byKeyPath: "updated")
    }
    private func getEndTime(from date: Date) -> Date{
        var components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        components.hour = 23
        components.minute = 59
        let endTime = Calendar.current.date(from: components)
        return endTime!
    }
}
