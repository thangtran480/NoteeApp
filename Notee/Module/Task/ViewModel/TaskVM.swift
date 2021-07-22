//
//  TaskVM.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 19/07/2021.
//

import RxCocoa
import RxSwift
import UserNotifications

class TaskVM: BaseViewModel {
    
    var taskObj: TaskObj?
    
    var title: BehaviorRelay<String>
    var remindDate: BehaviorRelay<Date?>
    var dueDate: BehaviorRelay<Date>
    var location: BehaviorRelay<String>
    var note: BehaviorRelay<String>
    var isRepeat: BehaviorRelay<Bool>
    var tapRepeat: PublishRelay<Void>
    var tapClearRemindDate: PublishRelay<Void>
    
    var service: TaskService!
    var coordinator: TaskCoordinator!
    
    init(service: TaskService, coordinator: TaskCoordinator) {
        self.remindDate = BehaviorRelay<Date?>(value: nil)
        self.title = BehaviorRelay<String>(value: "")
        self.dueDate = BehaviorRelay<Date>(value: Date())
        self.location = BehaviorRelay<String>(value: "")
        self.note = BehaviorRelay<String>(value: "")
        self.isRepeat = BehaviorRelay<Bool>(value: false)
        self.tapRepeat = PublishRelay<Void>()
        self.tapClearRemindDate = PublishRelay<Void>()
        
        self.service = service
        self.coordinator = coordinator
        
        super.init()
    }
    
    init(service: TaskService, coordinator: TaskCoordinator, taskObj: TaskObj) {
        self.taskObj = taskObj
        
        self.remindDate = BehaviorRelay<Date?>(value: taskObj.remindDate)
        self.title = BehaviorRelay<String>(value: taskObj.title)
        self.dueDate = BehaviorRelay<Date>(value: taskObj.dueDate)
        self.location = BehaviorRelay<String>(value: taskObj.location)
        self.note = BehaviorRelay<String>(value: taskObj.note)
        self.isRepeat = BehaviorRelay<Bool>(value: taskObj.isRepeat)
        self.tapRepeat = PublishRelay<Void>()
        self.tapClearRemindDate = PublishRelay<Void>()
        
        
        self.service = service
        self.coordinator = coordinator
        
        super.init()
    }
    
    override func subscriber() {
        self.tapRepeat.bind { _ in
            self.isRepeat.accept(!self.isRepeat.value)
        }.disposed(by: disposeBag)
        
        self.tapClearRemindDate.bind { _ in
            self.remindDate.accept(nil)
        }.disposed(by: disposeBag)
    }
    
    func save(){
        let task = TaskObj(title: title.value,
                              note: note.value,
                              label: "",
                              isRepeat: isRepeat.value,
                              location: location.value,
                              isComponent: false,
                              remindDate: remindDate.value,
                              dueDate: dueDate.value,
                              isStar: false)
        
        if self.taskObj == nil{
            service.addTask(task)
            Logger("Add Task", task)
        }else{
            self.removeNotification(taskObj: task)
            self.taskObj?.updateTaskObj(taskObj: task)
            Logger("Update Task", task)
        }
        if  let _ = task.remindDate {
            createNotification(taskObj: task)
        }
        self.coordinator.backToCalendar()
    }
    
    private func createNotification(taskObj: TaskObj){
        let content = UNMutableNotificationContent()
        content.title = taskObj.title
        content.body = taskObj.note
        content.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute],
            from: taskObj.remindDate!)
        Logger("Remind", dateComponents)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: taskObj.isRepeat)
        let request = UNNotificationRequest(identifier: "Notee.\(taskObj.id)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                Logger("Remind ERROR", error ?? "Success")
            }
        }
    }
    private func removeNotification(taskObj: TaskObj){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Notee.\(taskObj.id)"])
    }
}
