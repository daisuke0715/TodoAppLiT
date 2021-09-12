//
//  MemoViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import UIKit

class MemoViewController: UIViewController {

    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    var datePicker: UIDatePicker = UIDatePicker()
    
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
    
    
    
    @IBAction func save(_ sender: Any) {
        // 入力されたデータをFireStoreに登録
        
    }
    

}
