//
//  TaskVC.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 16/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class TaskVC: BaseViewController {

    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var tvNote: UITextView!
    @IBOutlet weak var tfLocation: UITextField!
    
    @IBOutlet weak var btnRemindMe: UIButton!
    @IBOutlet weak var btnAddDueDate: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnClearRemindMe: UIButton!
    
    var viewModel: TaskVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        tvTitle.placeholder = "Title"
        tvNote.placeholder = "Note"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
        
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.tvTitle.resignFirstResponder()
        self.tvNote.resignFirstResponder()
        self.tfLocation.resignFirstResponder()
    }

    override func bindView() {
        
        self.tvTitle.rx.text
            .orEmpty
            .bind(to: self.viewModel.title)
            .disposed(by: disposeBag)
        self.tvNote.rx.text
            .map { note in
                note?.trimmingCharacters(in: .whitespaces) ?? ""
            }
            .bind(to: self.viewModel.note)
            .disposed(by: disposeBag)
        self.tfLocation.rx.text
            .map { location in
                location?.trimmingCharacters(in: .whitespaces) ?? ""
            }
            .bind(to: self.viewModel.location)
            .disposed(by: disposeBag)
        
        self.btnRepeat.rx.tap.bind(to: self.viewModel.tapRepeat)
            .disposed(by: disposeBag)
        
        self.btnClearRemindMe.rx.tap.bind(to: self.viewModel.tapClearRemindDate)
            .disposed(by: disposeBag)
    }
    override func subscriber() {
        super.subscriber()
        
        // Due Date
        self.viewModel.dueDate
            .bind { date in
                self.btnAddDueDate.setTitleColor(UIColor.blue, for: .normal)
                self.btnAddDueDate.setTitle("Add Due Date\n\(Util.cvtDateToString(date))", for: .normal)
            }
            .disposed(by: disposeBag)
        
        // Remind Date
        self.viewModel.remindDate
            .bind { date in
                if let remindDate = date{
                    self.btnRemindMe.setTitleColor(UIColor.blue, for: .normal)
                    self.btnRemindMe.setTitle("Remind Me\n\(Util.cvtDateTimeToString(remindDate))", for: .normal)
                    self.btnClearRemindMe.isHidden = false
                }else{
                    self.btnRemindMe.setTitleColor(UIColor.darkGray, for: .normal)
                    self.btnRemindMe.setTitle("Remind Me", for: .normal)
                    self.btnClearRemindMe.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        // isRepeat
        self.viewModel.isRepeat
            .bind { isRepeat in
                if isRepeat{
                    self.btnRepeat.setTitleColor(UIColor.blue, for: .normal)
                }else{
                    self.btnRepeat.setTitleColor(UIColor.darkGray, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        // Title
        self.viewModel.title
            .bind { title in
                self.tvTitle.setText(title)
            }
            .disposed(by: disposeBag)
        
        // Note
        self.viewModel.note
            .bind { note in
                self.tvNote.setText(note)
            }
            .disposed(by: disposeBag)
        
        // Location
        self.viewModel.location
            .bind { location in
                self.tfLocation.text = location
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backItem?.title = ""
        self.title = "Add Task"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(actionSave(_:)))
        
    }
    @objc func actionSave(_ sender: UIBarButtonItem){
        self.viewModel.save()
    }
    
    @IBAction func actionBtnRemindMe(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Pick a date & time")
        alert.addDatePicker(mode: .dateAndTime, date: self.viewModel.remindDate.value, minimumDate: nil, maximumDate: nil) { date in
            self.viewModel.remindDate.accept(date)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    @IBAction func actionBtnDueDate(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Pick a date")
        alert.addDatePicker(mode: .date, date: self.viewModel.dueDate.value, minimumDate: nil, maximumDate: nil) { date in
            self.viewModel.dueDate.accept(date)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @IBAction func actionBtnRepeat(_ sender: Any) {
        
    }
    
}
