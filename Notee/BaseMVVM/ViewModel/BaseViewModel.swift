//
//  BaseViewModel.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 16/07/2021.
//

import RealmSwift
import RxSwift
import RxCocoa


class BaseViewModel {
    
    var isLoading: PublishRelay<Bool>
    var showMessageSuccess: PublishRelay<String>
    var showMessageError: PublishRelay<String>
    
    var disposeBag = DisposeBag()
    
    init() {
        self.isLoading = PublishRelay<Bool>()
        self.showMessageSuccess = PublishRelay<String>()
        self.showMessageError = PublishRelay<String>()
        
        subscriber()
    }
    
    func subscriber(){
        
    }
}
