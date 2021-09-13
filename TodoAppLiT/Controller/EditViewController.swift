//
//  EditViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/12.
//

import UIKit
import FirebaseFirestore

class EditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var todoTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    var datePicker: UIDatePicker = UIDatePicker()
    let alert: Alert = Alert()
    let db = Firestore.firestore()
    
    var parameters: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTextField.delegate = self
        detailTextField.delegate = self
        dateTextField.delegate = self
        
        todoTextField.text = parameters["todo"]
        detailTextField.text = parameters["detail"]
        dateTextField.text = parameters["date"]
        
        // ピッカーの設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        dateTextField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDate))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビューの設定
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
    }
    
    
    @objc func doneDate() {
        dateTextField.endEditing(true)
                
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = "\(formatter.string(from: Date()))"
    }
    
    @IBAction func done(_ sender: Any) {
        
        // ========================================
        // FireStoreのデータを更新する処理
        
        // 入力されたデータをFireStoreに登録
        if let _todoText = todoTextField.text,
            let _detailText = detailTextField.text,
            let _dateText = dateTextField.text {
            // 全ての値がnullじゃなかっらFireStoreへの保存を実行
            
        // ========================================
            self.navigationController?.popViewController(animated: true)
            
        } else {
            // どれかがnullだった時の処理
            alert.failedAlert(titleText: "入力してください", actionTitleText: "OK", message: "入力が完了していません。")
        }
    }
    
    
    // テキストビューを監視
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
            if self.todoTextField.text == "" ||
                self.detailTextField.text == "" ||
                self.dateTextField.text == "" {
                self.doneButton.isEnabled = false
            } else {
                self.doneButton.isEnabled = true
            }
        }
        return true
    }
    
}
