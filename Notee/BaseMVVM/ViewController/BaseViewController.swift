//
//  BaseViewController.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 15/07/2021.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController{
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        subscriber()
        bindView()
    }
    
    func setupView(){
        
    }
    func setupData(){
        
    }
    
    func subscriber(){
        
    }
    func bindView(){
        
    }
    
    func subcriberCommon(_ viewModel: BaseViewModel){

        let _ = viewModel.isLoading.bind(onNext: { (loading) in
            if (loading){
                LoadingCommon.start()
            }else{
                LoadingCommon.stop()
            }
        }).disposed(by: disposeBag)
        
    }
}
