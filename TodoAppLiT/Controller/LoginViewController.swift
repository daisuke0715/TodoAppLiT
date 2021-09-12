//
//  LoginViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let alert: Alert = Alert()
    let loadingIcon: LoadingIcon = LoadingIcon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginEmailTextField.layer.cornerRadius = 10
        loginPasswordTextField.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if (authResult?.user) != nil {
                    self.loadingIcon.presentLoadingIcon()
                    self.performSegue(withIdentifier: "toFirstView", sender: nil)
                } else if error != nil {
                    let dialog = self.alert.failedAlert(titleText: "ログイン失敗", actionTitleText: "OK", message: (error?.localizedDescription.description)!)
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func moveSignUp(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
        let remindPasswordAlert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
        remindPasswordAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        remindPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (alertAction) in
            let resetEmail = remindPasswordAlert.textFields?.first?.text
            print(resetEmail!)
            Auth.auth().sendPasswordReset(withEmail: resetEmail!) { (error) in
                DispatchQueue.main.async {
                    if error == nil {
                        let dialog = self.alert.resetMailAlert(title: "メールを送信しました", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
                        self.present(dialog, animated: true, completion: nil)
                    } else {
                        let dialog = self.alert.resetMailAlert(title: "エラー", message: "このメールアドレスは登録されてません。", actiontitle: "OK")
                        self.present(dialog, animated: true, completion: nil)
                    }
                }
            }
        }))
        
        remindPasswordAlert.addTextField { (textField) in
            textField.placeholder = "登録メールアドレスを入力してください。"
        }
        self.present(remindPasswordAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

}
