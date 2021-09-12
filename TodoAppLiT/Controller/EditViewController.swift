//
//  EditViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/12.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet var todoTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var datePicker: UIDatePicker = UIDatePicker()
    let alert: Alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // 入力されたデータをFireStoreに登録
        if let _todoText = todoTextField.text,
            let _detailText = detailTextField.text,
            let _dateText = dateTextField.text {
            // 全ての値がnullじゃなかっらFireStoreへの保存を実行
                        
            self.navigationController?.popViewController(animated: true)
            
        } else {
            // どれかがnullだった時の処理
            alert.failedAlert(titleText: "入力してください", actionTitleText: "OK", message: "入力が完了していません。")
        }
    }
    
}
