//
//  AuthViewController.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 29.11.2022.
//

import UIKit

class AuthViewController: UIViewController {

    var delegate: LoginViewControllerDelegate!
    var checkField = CheckField.shared
    var service = Service.shared
    var userDefaults = UserDefaults.standard
    
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
    
    @IBAction func closeAuthVC(_ sender: Any) {
        delegate.closeVC() 
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBAction func forgotPass(_ sender: Any) {
    }
    
    @IBAction func toReg(_ sender: Any) {
        delegate.closeVC()
        delegate.openRegVC()
    }
    
    @IBAction func authButton(_ sender: Any) {
        if  checkField.validField(emailView, emailField),
            checkField.validField(passwordView, passwordField) {
            let authData = LoginField(email: emailField.text ?? "", password: passwordField.text ?? "")
            service .authInApp(authData) { [weak self] response in
                switch response {
                case .succses:
                    self?.userDefaults.set(true, forKey: "isLogin")
                    self?.delegate.startApp()
                    self?.delegate.closeVC()
                case .error:
                    let alert = self?.alertAction("Ошибка!", "Неверный Email или пароль")
                    let verifyButton = UIAlertAction(title: "Ок", style: .default)
                    alert?.addAction(verifyButton)
                    self?.present(alert!, animated: true)
                    
                case .notVerified:
                    let alert = self?.alertAction("Ошибка!", "Email не верифицирован. На вашу почту отправлена ссылка для верификации")
                    let verifyButton = UIAlertAction(title: "Ок", style: .default)
                    alert?.addAction(verifyButton)
                    self?.present(alert!, animated: true)
                    
                }
            }
        }
        else {
            let alert = self.alertAction("Ошибка!", "Проверьте введенные данные")
            let verifyButton = UIAlertAction(title: "Ок", style: .cancel)
            alert.addAction(verifyButton)
            self.present(alert, animated: true)
        }
        
    }
    
    func alertAction(_ header: String?, _ message: String?) -> UIAlertController {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        return alert
    }

}
