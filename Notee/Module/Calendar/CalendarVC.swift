//
//  CalendarVC.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 15/07/2021.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa

class CalendarVC: BaseViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel : CalendarVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let date = self.calendarView.selectedDate{
            self.viewModel.dateSelected.accept(date)
        }
    }
    
    override func setupView(){
        self.view.addGestureRecognizer(self.scopeGesture)
        
        setupCalendarView()
        setupCollectionView()
        
        subcriberCommon(self.viewModel)
        btnAddTask.layer.cornerRadius = 5
        btnAddTask.backgroundColor = UIColor.blue
        btnAddTask.tintColor = UIColor.white
    }
    
    override func subscriber(){
        let _ = self.btnAddTask.rx.tap.bind(to: viewModel.tapBtnAddTask)
    }
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    private func setupCalendarView(){
        calendarView.delegate = self
        calendarView.dataSource = self
        
        self.calendarView.select(Date())
        
        self.calendarView.addGestureRecognizer(self.scopeGesture)
        self.calendarView.scope = .week
        self.calendarView.allowsMultipleSelection = false
        self.calendarView.firstWeekday = 2
        self.calendarView.appearance.todaySelectionColor = UIColor.black
    }
    
    private func setupCollectionView() {
        
        collectionView.register(CalendarCollectionCell.self, forCellWithReuseIdentifier: CalendarCollectionCell.CellIndentifier)
        collectionView.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    override func bindView() {
        super.bindView()
        viewModel.listTask
            .bind(to: collectionView.rx.items(cellIdentifier: CalendarCollectionCell.CellIndentifier, cellType: CalendarCollectionCell.self))
            {index, model, cell in
                cell.setTaskObj(taskObj: model)
                cell.delegate = self
                cell.index = index
        }.disposed(by: disposeBag)
    }
    
}

extension CalendarVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectedItemCollection.accept(indexPath.row)
    }
    
}
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.viewModel.dateSelected.accept(date)
    }
    
}

extension CalendarVC: CalendarCollectionCellDelegate{
    func tapComplete(_ index: Int) {
        self.viewModel.tapComplete.accept(index)
    }
    
    func tapStar(_ index: Int) {
        self.viewModel.tapStar.accept(index)
    }
    
}
