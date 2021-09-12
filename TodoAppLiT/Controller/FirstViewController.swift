//
//  FirstViewController.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    var memoDataArray: [MemoDataStore]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirstViewTableViewCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as! FirstViewTableViewCell
        
        let ref = db.collection("todos")
        ref.getDocuments { [self] (snaps, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
               
                self.memoDataArray = snaps!.documents.map { document -> MemoDataStore in
                    let data = MemoDataStore(document: document)
                    return data
                }
                cell.setCell(memo: self.memoDataArray[indexPath.row].todoText!, date: self.memoDataArray[indexPath.row].dateText!)
            }
        }
        
        return cell
    }
    
    // セルの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルのスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            memoDataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
            // ========================================
            // FireStoreでデータを削除する処理
            
            
            // ========================================
            
        }
        
    }
    
    // セルがクリックされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let editVC = segue.destination as! EditViewController
            editVC.todoText = "aaa"
            editVC.detailText = "aaaa"
            
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        if currentUser != nil {
            let dialog = UIAlertController(title: "ログアウト", message: "本当にログアウトしますか？", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                do {
                    try Auth.auth().signOut()
                    self.dismiss(animated: true, completion: nil)
                } catch let error as NSError {
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


class MemoDataStore: NSObject{
    var todoText: String?
    var dateText: String?
    init(document: QueryDocumentSnapshot) {
        let dic = document.data()
        self.todoText = dic["todo"] as! String
        self.dateText = dic["date"] as! String
    }

}
