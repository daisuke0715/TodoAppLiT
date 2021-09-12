//
//  Alert.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import Foundation
import UIKit

public class Alert {
    func resetMailAlert(title:String, message:String, actionTitle:String) -> UIAlertController{
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        return dialog
    }
    
    func failedAlert(titleText: String, actionTitleText: String, message: String) -> UIAlertController {
        let dialog = UIAlertController(title: titleText, message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: actionTitleText, style: .default, handler: nil))
        return dialog
    }
    
}
