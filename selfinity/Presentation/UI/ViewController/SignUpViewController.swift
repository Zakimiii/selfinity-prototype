//
//  SignUpViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Toaster

@objcMembers
class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: GradationButton! {
        didSet {
            signUpButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            signUpButton.layer.shadowOpacity = 0.3
            signUpButton.layer.shadowOffset = CGSize.zero
            signUpButton.layer.shadowRadius = 15
            signUpButton.layer.shadowPath = UIBezierPath(roundedRect: signUpButton.bounds, cornerRadius: 15).cgPath
            signUpButton.layer.shouldRasterize = true
            signUpButton.layer.rasterizationScale = UIScreen.main.scale
            signUpButton.button.addTarget(self, action: #selector(self.tapSignUpButton), for: .touchUpInside)
        }
    }
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    
    fileprivate var presenter: SignInPresenter?
    
    func inject(presenter: SignInPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInViewControllerBuilder.rebuild(self)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tapSignUpButton() {
        self.presenter?.didTapSignInButton(name: self.nameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            self.tapSignUpButton()
        } else if textField == nameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}

extension SignUpViewController: SignInPresenterInput {
    func endAuth() {
        self.performSegue(withIdentifier: R.segue.signUpViewController.toMain, sender: nil)
    }
    func failAuth() {
        Toast(text: R.string.localizable.loginErrorText()).show()
    }
}
