//
//  MemoViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import UIKit
import FirebaseFirestore

class MemoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var datePicker: UIDatePicker = UIDatePicker()
    let alert: Alert = Alert()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTextField.delegate = self
        dateTextField.delegate = self
        dateTextField.delegate = self
        
        // ピッカーの設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDate))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビューの設定
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
        saveButton.isEnabled = false
        
    }
    

    @objc func doneDate() {
        dateTextField.endEditing(true)
                
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = "\(formatter.string(from: Date()))"
    }
    
    
    
    @IBAction func save(_ sender: Any) {
        
        if let _todoText = todoTextField.text,
           let _detailText = detailTextField.text,
           let _dateText = dateTextField.text {
        db.collection("todos").document().setData(["todo": _todoText, "detail": _detailText, "date": _dateText], merge: true)
        
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // テキストビューを監視
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
            if self.todoTextField.text == "" ||
                self.detailTextField.text == "" ||
                self.dateTextField.text == "" {
                self.saveButton.isEnabled = false
            } else {
                self.saveButton.isEnabled = true
            }
        }
        return true
    }

}
