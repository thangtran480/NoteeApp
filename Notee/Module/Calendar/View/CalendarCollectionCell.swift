//
//  CalendarCollectionCell.swift
//  Notee
//
//  Created by VTS-ThangTV28 on 16/07/2021.
//

import UIKit
import Foundation

protocol CalendarCollectionCellDelegate {
    func tapComplete(_ index: Int)
    func tapStar(_ index: Int)
}

class CalendarCollectionCell: UICollectionViewCell {
    
    static let CellIndentifier = "CalendarCollectionCell"
    
    private var lbTitle: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.boldSystemFont(ofSize: 18)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    private var btnImgComplete: UIButton =
    {
        let image = UIImage(named: "check")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var stackMore : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private var btnImgStar: UIButton = {
        let image = UIImage(named: "star")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
    private var lbTime: UILabel = {
        let labelView = UILabel()
        labelView.font = UIFont.systemFont(ofSize: 15)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    
    var taskObj: TaskObj!
    var delegate: CalendarCollectionCellDelegate!
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func setTaskObj(taskObj: TaskObj){
        self.taskObj = taskObj
        self.setupView()
        
        lbTitle.text = taskObj.title
        
    }
    private func setupView(){
        
        self.contentView.addSubview(btnImgComplete)
        btnImgComplete.addTarget(self, action: #selector(actionTapBtnComplete(_:)), for: .touchUpInside)
        if (taskObj.isComplete){
            btnImgComplete.setImage(UIImage(named: "checked"), for: .normal)
        }else{
            btnImgComplete.setImage(UIImage(named: "check"), for: .normal)
        }
        let constraintImgComplete = [
            btnImgComplete.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            btnImgComplete.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            btnImgComplete.heightAnchor.constraint(equalToConstant: 20),
            btnImgComplete.widthAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraintImgComplete)
        
        self.contentView.addSubview(btnImgStar)
        btnImgStar.addTarget(self, action: #selector(actionTapBtnStar(_:)), for: .touchUpInside)
        if (taskObj.isStar){
            btnImgStar.setImage(UIImage(named: "star.fill"), for: .normal)
        }else{
            btnImgStar.setImage(UIImage(named: "star"), for: .normal)
        }
        let constraintImgStar = [
            btnImgStar.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            btnImgStar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            btnImgStar.heightAnchor.constraint(equalToConstant: 20),
            btnImgStar.widthAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraintImgStar)
        
        
        self.contentView.addSubview(lbTitle)
        let constraintLbTitle = [
            lbTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            lbTitle.leadingAnchor.constraint(equalTo: self.btnImgComplete.trailingAnchor, constant: 20),
            lbTitle.trailingAnchor.constraint(equalTo: self.btnImgStar.leadingAnchor, constant: -10),
            lbTitle.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraintLbTitle)
        stackMore.removeAllArrangedSubviews()
        
        self.contentView.addSubview(stackMore)
        let constraintStackMore = [
            stackMore.topAnchor.constraint(equalTo: self.lbTitle.bottomAnchor),
            stackMore.leadingAnchor.constraint(equalTo: self.lbTitle.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraintStackMore)
        
        if let _ = taskObj.remindDate{
            self.addViewNotification()
        }
        if taskObj.isRepeat{
            self.addViewRepeat()
        }
        
    }
    
    func addViewNotification(){
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let notiImageView = UIImageView(image: UIImage(named: "bell"))
        notiImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notiImageView)
        
        notiImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        notiImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        notiImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(label)
        if let date = taskObj.remindDate {
            label.text = Util.cvtDateToString(date)
        }
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: notiImageView.trailingAnchor, constant: 4).isActive = true
       
        view.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        self.stackMore.addArrangedSubview(view)
    }
    func addViewRepeat(){
        let repeatImageView = UIImageView(image: UIImage(named: "repeat"))
        repeatImageView.translatesAutoresizingMaskIntoConstraints = false
        
        repeatImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        repeatImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        
        self.stackMore.addArrangedSubview(repeatImageView)
    }
    
    @objc func actionTapBtnComplete(_ sender: AnyObject) {
        delegate.tapComplete(index)
    }
    @objc func actionTapBtnStar(_ sender: AnyObject) {
        delegate.tapStar(index)
    }
}
