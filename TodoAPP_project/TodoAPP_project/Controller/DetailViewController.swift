//
//  DetailViewController.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 11/26/23.
//

import UIKit
import SnapKit

final class DetailViewController : UIViewController {
    private let todoManager = TodoManager.shared
    
    var indexNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = .darkGreen
        
        self.hideKeyboardWhenTappedAround()

        setLayout()
        configureDatePicker()
    }
        
    var detailViewTitle : UITextField = {
        var textField = UITextField()
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.darkYellow.cgColor
        textField.layer.backgroundColor = UIColor.darkYellow.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        return textField
    }()
    
    private let dateConfigureLabel : UILabel = {
        let label = UILabel()
        label.text = "날짜 선택"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    private lazy var endDateView : DateSelectView = {
        let view = DateSelectView()
        view.dateLabel.text = "마감일"
        
        return view
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        return label
    }()
    
    var descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 15
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 17, weight: .light)
        
        
        return textView
    }()
    
    private lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.borderWidth = 10
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.darkGreen.cgColor
        button.layer.backgroundColor = UIColor.darkGreen.cgColor
        button.addTarget(self, action: #selector(tabSaveButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tabSaveButton(_ :UIButton) {
        let cellData = todoManager.todoAllDataSource[indexNumber]
        let id = cellData.id
        var title = cellData.title
        
        let selectedEndDate = endDateView.dataPicker.date.toString()
        let description = descriptionTextView.text
            
        if let todoTitle = detailViewTitle.text {
            title = todoTitle
        }
        else { title = cellData.title }
        
        let requestBody = RequestDTO(
            title: title ,
            description: description ?? "",
            endDate: selectedEndDate
        )
        
        todoManager.todoAllDataSource[indexNumber].title = title
        todoManager.todoAllDataSource[indexNumber].description = description
        todoManager.todoAllDataSource[indexNumber].endDate = selectedEndDate

        Task {
            try await TodoAPI.modifyTodo(id: id, requestBody).performRequest(with: requestBody)
        }
        configureDatePicker()
        
        navigationController?.popViewController(animated: false)
    }
    
    private func configureDatePicker() {
        let endDate = todoManager.todoAllDataSource[indexNumber].endDate
        endDateView.dataPicker.date = endDate?.toDate() ?? Date.now
        print(endDate)
    }
    
    private func setLayout() {
        [detailViewTitle,
         dateConfigureLabel,
         endDateView,
         descriptionLabel,
         descriptionTextView,
         saveButton].forEach {
            view.addSubview($0)
        }
        
        detailViewTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(50)
        }
        
        dateConfigureLabel.snp.makeConstraints {
            $0.top.equalTo(detailViewTitle.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        endDateView.snp.makeConstraints {
            $0.top.equalTo(dateConfigureLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(endDateView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(150)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.snp.bottom).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.width.equalTo(60)
        }
    }
}

 
