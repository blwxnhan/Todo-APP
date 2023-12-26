//
//  LoginViewController.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 11/30/23.
//

import UIKit
import SnapKit

final class LoginViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setLayout()
    }
    
    private let loginLabel : UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = .darkGreen
        label.font = UIFont.systemFont(ofSize: 50, weight: .black)
        label.textAlignment = .center
        
        return label
    }()
    
    let idInputView : InputView = {
        let inputView = InputView()
        inputView.inputLabel.text = "email"
        inputView.inputTextField.placeholder = "email을 입력하세요."
        
        return inputView
    }()
    
    let passwordInputView : InputView = {
        let inputView = InputView()
        inputView.inputLabel.text = "password"
        inputView.inputTextField.placeholder = "password를 입력하세요."

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
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var joinButton : UIButton = {
        let button = UIButton()
        button.setTitle("join", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 10
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.darkYellow.cgColor
        button.layer.backgroundColor = UIColor.darkYellow.cgColor
        button.addTarget(self, action: #selector(tabJoinButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("login", for: .normal)
        button.tintColor = .systemGray
        button.layer.borderWidth = 10
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.darkGreen.cgColor
        button.layer.backgroundColor = UIColor.darkGreen.cgColor
        button.addTarget(self, action: #selector(tabLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func tabLoginButton(_: UIButton) {
        var loginSuccess = false
        
        var todoId = ""
        var todoPassword = ""
        
        if let id = idInputView.inputTextField.text {
            todoId = id
        }
        
        if let password = passwordInputView.inputTextField.text {
            todoPassword = password
        }
        
        if (idInputView.inputTextField.text == "" ||
            passwordInputView.inputTextField.text == "") {
            invaildInputLabel.text = "이메일과 비밀번호를 입력해주세요"
        }
        
        else {
            Task {
                loginSuccess = try await TokenAPI.login(todoId, todoPassword).performRequest()
                
                if loginSuccess == true {
                    let tabBarVC = TabBarController()
                    tabBarVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    self.present(tabBarVC, animated: false, completion: nil)
                }
                else {
                    invaildInputLabel.text = "이메일과 비밀번호를 다시 입력해주세요"
                }
            }
        }
    }
    
    @objc private func tabJoinButton(_: UIButton) {
        let joinVC = JoinViewController()
        joinVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(joinVC, animated: false, completion: nil)
    }
    
    private func setLayout() {
        [joinButton, loginButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [loginLabel,
         idInputView,
         passwordInputView,
         invaildInputLabel,
         buttonStackView].forEach{
            view.addSubview($0)
        }
        
        joinButton.snp.makeConstraints {
            $0.width.equalTo(100)
        }
    
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        idInputView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        passwordInputView.snp.makeConstraints {
            $0.top.equalTo(idInputView.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(passwordInputView.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        invaildInputLabel.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.height.equalTo(15)
        }
    }
}
