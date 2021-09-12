//
//  SignUpViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import Foundation
import UIKit
import AuthenticationServices
import Firebase
import FirebaseAuth
import CryptoKit
import FirebaseFirestore

class SignUpViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, UITextFieldDelegate {
    
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    let loadingIcon: LoadingIcon = LoadingIcon()
    let alert: Alert = Alert()
    var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        registerButton.layer.cornerRadius = 10
        appleButton.layer.cornerRadius = 10
        registerEmailTextField.layer.cornerRadius = 10
        registerPasswordTextField.layer.cornerRadius = 10
        registerNameTextField.layer.cornerRadius = 10
        registerEmailTextField.delegate = self
        registerPasswordTextField.delegate = self
        registerNameTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let email = registerEmailTextField.text,
           let password = registerPasswordTextField.text,
           let name = registerNameTextField.text {
            loadingIcon.presentLoadingIcon()
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in })
                if let user = authResult?.user {
                    Firestore.firestore().collection("users").document(user.uid).setData(["userId": user.uid, "mail": email ,"name": name, "problemCount": 0], merge: true) { [self] (error) in
                        if error != nil {
                            let dialog = self.alert.failedAlert(titleText: "新規登録失敗", actionTitleText: "OK", message: (error?.localizedDescription.description)!)
                            self.present(dialog, animated: true, completion: nil)
                        } else {
                            self.performSegue(withIdentifier: "toFirstView", sender: nil)
                        }
                    }
                } else if error != nil {
                    let dialog = self.alert.failedAlert(titleText: "新規登録失敗", actionTitleText: "OK", message: (error?.localizedDescription.description)!)
                    self.present(dialog, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func appleSignIn(_ sender: Any) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handle(authorization.credential)
    }
    
    func handle(_ credential: ASAuthorizationCredential) {
        
        guard let appleIDCredential = credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            return
        }
        
        let oAuthCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: oAuthCredential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            if let user = authResult?.user, let email = appleIDCredential.email, let fullName = appleIDCredential.fullName?.givenName {
            
                Firestore.firestore().collection("users").document(user.uid).setData(["userId": user.uid, "mail": email ,"name": fullName , "problemCount": 0], merge: true) { (error) in
                    if error != nil {
                        let dialog = self.alert.failedAlert(titleText: "新規登録失敗", actionTitleText: "OK", message: (error?.localizedDescription.description)!)
                        self.present(dialog, animated: true, completion: nil)
                    } else {
                        UserDefaults.standard.set(true, forKey: "visit")
                        self.performSegue(withIdentifier: "toFirstView", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
