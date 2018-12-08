//
//  LogInViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Toaster
import Firebase

@objcMembers
class LogInViewController: UIViewController {

    @IBOutlet weak var logInButton: GradationButton! {
        didSet {
            logInButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            logInButton.layer.shadowOpacity = 0.3
            logInButton.layer.shadowOffset = CGSize.zero
            logInButton.layer.shadowRadius = 15
            logInButton.layer.shadowPath = UIBezierPath(roundedRect: logInButton.bounds, cornerRadius: 15).cgPath
            logInButton.layer.shouldRasterize = true
            logInButton.layer.rasterizationScale = UIScreen.main.scale
            logInButton.button.addTarget(self, action: #selector(self.tapLogInButton), for: .touchUpInside)
        }
    }
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    fileprivate var presenter: LogInPresenter?
    
    func inject(presenter: LogInPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogInViewControllerBuilder.rebuild(self)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tapLogInButton() {
        self.presenter?.didTapLogInButton(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            self.tapLogInButton()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}

extension LogInViewController: LogInPresenterInput {
    func failAuth() {
        Toast(text: R.string.localizable.loginErrorText()).show()
    }
    
    func endAuth() {
        self.performSegue(withIdentifier: R.segue.logInViewController.toMain, sender: nil)
    }
    
}
