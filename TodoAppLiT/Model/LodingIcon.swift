//
//  LodingIcon.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import Foundation
import UIKit

public class LoadingIcon {
    let loadingView = UIView(frame: UIScreen.main.bounds)
    
    func presentLoadingIcon() {
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = loadingView.center
        activityIndicator.color = UIColor.white
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        label.center = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 90)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "ただいま処理中です..."
        loadingView.addSubview(label)
        
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.addSubview(loadingView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.loadingView.removeFromSuperview()
        })
    }
    
    func removeLoadingIcon() {
        loadingView.removeFromSuperview()
    }
    
}

