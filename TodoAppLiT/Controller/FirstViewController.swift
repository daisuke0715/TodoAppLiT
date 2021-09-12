//
//  FirstViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        // 毎回TableViewのデータをリロードする
        tableView.reloadData()
    }
    
    
    func getData() {
        // FireStoreに保存されているデータを取得
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as! FirstViewTableViewCell
        
        cell.setCell(memo: "メモのデータ", date: "日付")
        
        return cell
    }
    
    // セルの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルのスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func logout(_ sender: Any) {
        if currentUser != nil {
            let dialog = UIAlertController(title: "ログアウト", message: "本当にログアウトしますか？", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                // ②ログアウトの処理
                do {
                    try Auth.auth().signOut()
                    // ③成功した場合はログイン画面へ遷移
                    self.dismiss(animated: true, completion: nil)
                } catch let error as NSError {
                    print("ログアウト処理失敗", error.localizedDescription)
                    // ②が失敗した場合
                    let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
            }))
            dialog.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            
            present(dialog, animated: true, completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}



