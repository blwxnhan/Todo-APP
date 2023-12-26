//
//  JoinViewController.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/1/23.
//

import UIKit
import SnapKit

final class JoinViewController : UIViewController {
    private let joinLabel : UILabel = {
        let label = UILabel()
        label.text = "Join"
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textColor = .darkGreen
        
        return label
    }()
    
    let joinNickname : InputView = {
        let inputView = InputView()
        inputView.inputLabel.text = "nickname"
        inputView.inputTextField.placeholder = "닉네임을 입력해주세요."
        
        return inputView
    }()
    
    let joinEmail : InputView = {
        let inputView = InputView()
        inputView.inputLabel.text = "email"
        inputView.inputTextField.placeholder = "email을 입력해주세요."
        
        return inputView
    }()
    
    let joinPassword : InputView = {
        let inputView = InputView()
        inputView.inputLabel.text = "password"
        inputView.inputTextField.placeholder = "비밀번호를 입력해주새요."
        
        return inputView
    }()
    
    var invaildInputLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
        
        return label
    }()
    
    private let buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var joinButton : UIButton = {
        let button = UIButton()
        button.setTitle("Join", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 10
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.darkGreen.cgColor
        button.layer.backgroundColor = UIColor.darkGreen.cgColor
        button.addTarget(self, action: #selector(tabJoinButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backLoginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 10
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.darkYellow.cgColor
        button.layer.backgroundColor = UIColor.darkYellow.cgColor
        button.addTarget(self, action: #selector(tabBackLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setLayout()
    }
    
    @objc private func tabBackLoginButton(_:UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc private func tabJoinButton(_:UIButton) {
        var joinSuccess = false
        
        var memberId = ""
        var memberPassword = ""
        var memberNickname = ""
        
        if let id = joinEmail.inputTextField.text {
            memberId = id
        }
        
        if let password = joinPassword.inputTextField.text {
            memberPassword = password
        }
        
        if let nickname = joinNickname.inputTextField.text {
            memberNickname = nickname
        }
        
        if (joinEmail.inputTextField.text == "" ||
            joinPassword.inputTextField.text == "" ||
            joinNickname.inputTextField.text == "") {
            invaildInputLabel.text = "이메일, 비밀번호, 닉네임을 입력해주세요"
        }
        
        else {
            let requestBody = Member(
                id: memberId,
                password: memberPassword,
                nickname: memberNickname
            )
            
            Task {
                joinSuccess = try await TokenAPI.join(requestBody).performRequest(with: requestBody)
                
                if joinSuccess == true {
                    self.dismiss(animated: false)
                }
                else {
                    invaildInputLabel.text = "이메일과 비밀번호를 다시 입력해주세요"
                }
            }
        }
    }
    
    private func setLayout() {
        [backLoginButton,joinButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [joinLabel,
         joinNickname,
         joinPassword,
         joinEmail,
         invaildInputLabel,
         buttonStackView].forEach {
            view.addSubview($0)
        }
                
        joinLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        joinNickname.snp.makeConstraints {
            $0.top.equalTo(joinLabel.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        joinEmail.snp.makeConstraints {
            $0.top.equalTo(joinNickname.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        joinPassword.snp.makeConstraints {
            $0.top.equalTo(joinEmail.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        invaildInputLabel.snp.makeConstraints {
            $0.top.equalTo(joinPassword.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(40)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(invaildInputLabel.snp.bottom).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(40)
        }
    }
}
