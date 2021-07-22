//
//  CalendarVM.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 16/07/2021.
//
import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class CalendarVM: BaseViewModel {
    
    var listTask: BehaviorRelay<Results<TaskObj>>
    var dateSelected: PublishRelay<Date>
    var tapBtnAddTask: PublishRelay<Void>
    var selectedItemCollection: PublishRelay<Int>
    var service: CalendarService
    var coordinator: CalendarCoordinator
    
    var tapComplete: PublishRelay<Int>
    var tapStar: PublishRelay<Int>
    
    init(_ service: CalendarService, _ coordinator: CalendarCoordinator) {
        
        
        self.service = service
        self.coordinator = coordinator
        
        let tasks = self.service.getAllTask()
        Logger("CalendarVM",  "getAllTask: \(tasks)")
        
        self.listTask = BehaviorRelay<Results<TaskObj>>(value: tasks)
        self.tapBtnAddTask = PublishRelay<Void>()
        self.dateSelected = PublishRelay<Date>()
        self.selectedItemCollection = PublishRelay<Int>()
        
        self.tapComplete = PublishRelay<Int>()
        self.tapStar = PublishRelay<Int>()
        
        super.init()
    }
    
    func getAllTask(_ date: Date = Date()){
        isLoading.accept(true)
        
        DispatchQueue.main.async {
            let tasks = self.service.getAllTaskByDate(date)
            Logger("CalendarVM",  "getAllTask by \(date): \(tasks)")
            self.listTask.accept(tasks)
            self.isLoading.accept(false)
        }
    }

    override func subscriber(){
        self.tapBtnAddTask.bind { (_) in
            self.coordinator.showTask()
        }.disposed(by: disposeBag)
        
        self.dateSelected.bind { date in
            self.getAllTask(date)
        }.disposed(by: disposeBag)
        
        self.selectedItemCollection.bind { index in
            self.coordinator.showTask(taskObj: self.listTask.value[index])
        }.disposed(by: disposeBag)
        
        self.tapStar.bind { index in
            let tasks = self.listTask.value
            tasks[index].updateIsStar(!tasks[index].isStar)
            self.listTask.accept(tasks)
        }.disposed(by: disposeBag)
        
        self.tapComplete.bind { index in
            let tasks = self.listTask.value
            tasks[index].updateIsComplete(!tasks[index].isComplete)
            self.removeNotification(taskObj: tasks[index])
            self.listTask.accept(tasks)
        }.disposed(by: disposeBag)
    }
    
    private func removeNotification(taskObj: TaskObj){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["Notee.\(taskObj.id)"])
    }
}
