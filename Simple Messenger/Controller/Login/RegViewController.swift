//
//  RegViewController.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 29.11.2022.
//

import UIKit

class RegViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate!
    var checkField = CheckField.shared
    var service = Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        mainView.addGestureRecognizer(tapGesture!)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var mainView: UIView!
    var tapGesture: UITapGestureRecognizer?
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func closeRegVC(_ sender: Any) {
        delegate.closeVC()
    }
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var rePassordField: UITextField!
    @IBOutlet weak var rePassorwView: UIView!
    
    @IBAction func toAuth(_ sender: Any) {
        delegate.closeVC()
        delegate.openAuthVC()
    }
    
    @IBAction func regButton(_ sender: Any) {
        if  checkField.validField(emailView, emailField),
            checkField.validField(passwordView, passwordField),
            checkField.validField(rePassorwView, rePassordField) {
            if    passwordField.text == rePassordField.text {
                service.createNewUser(LoginField(email: emailField.text ?? "", password: passwordField.text ?? "")) { [weak self] response in
                    switch response {
                    case .error:
                        print("Ошибка регистрации")
                    case .succses:
                        self?.service.confirmEmail()
                        let alert = UIAlertController(title: "", message: "Регистрация прошла успешно", preferredStyle: .alert)
                        let alertButton = UIAlertAction(title: "Авторизоваться", style: .default) { _ in
                            self?.delegate.closeVC()
                            self?.delegate.openAuthVC()
                        }
                        alert.addAction(alertButton)
                        self?.present(alert, animated: true)
                        
                    default:
                        print("Неизвестная ошибка")
                    }
                }
            }
        }
        
    }
    
}
