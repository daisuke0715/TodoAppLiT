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
    var docID: String!
    
    var parameters: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTextField.delegate = self
        detailTextField.delegate = self
        dateTextField.delegate = self
        todoTextField.text = parameters["todo"]
        detailTextField.text = parameters["detail"]
        dateTextField.text = parameters["date"]
        docID = parameters["docID"]
        
        // ピッカーの設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
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
        db.collection("todos").getDocuments { snaps, err in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            // FireStoreのデータを更新する処理（入力されたデータをFireStoreに登録）
            // 全ての値がnullじゃなかっらFireStoreへの保存を実行
            if let _todoText = self.todoTextField.text,
               let _detailText = self.detailTextField.text,
               let _dateText = self.dateTextField.text {
                let id = snaps?.documents.first?.documentID
                let document = self.db.collection("todos").document(id!)
                document.setData(["todos": _todoText, "detail": _detailText, "date": _dateText]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Update successfully!")
                    }
                }
            } else {
                // どれかがnullだった時の処理
                self.alert.failedAlert(titleText: "入力してください", actionTitleText: "OK", message: "入力が完了していません。")
            }
        }
        sleep(3)
        self.navigationController?.popViewController(animated: true)
    }
    
}
