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
    var memoDataArray: [MemoDataStore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FirstViewTableViewCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 毎回表示の際に取得して、データ取得完了次第、reloadData()してくれるように、viewWillAppearの中に記述する
        memoDataArray = getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as! FirstViewTableViewCell
        cell.setCell(memo: memoDataArray[indexPath.row].todoText!, date: memoDataArray[indexPath.row].dateText!)
        return cell
    }
    
    // セルがクリックされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parameters = ["todo": memoDataArray[indexPath.row].todoText, "detail": memoDataArray[indexPath.row].detailText, "date": memoDataArray[indexPath.row].dateText]
        performSegue(withIdentifier: "toEdit", sender: parameters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let editVC = segue.destination as! EditViewController
            editVC.parameters = sender as! [String : String]
        }
    }
    
    func getData() -> [MemoDataStore] {
        let ref = db.collection("todos")
        print("ref:", ref)
        ref.getDocuments { (snaps, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            self.memoDataArray = snaps!.documents.map { document -> MemoDataStore in
                let data = MemoDataStore(document: document)
                return data
            }
            // データ取得が終わったタイミングでtableViewをリロードデータ（LiveDataみたいなんあったらこれタイミングよしなにしてくれる）
            self.tableView.reloadData()
        }
        return memoDataArray
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
    var detailText: String?
    var dateText: String?
    init(document: QueryDocumentSnapshot) {
        let dic = document.data()
        self.todoText = dic["todo"] as? String
        self.detailText = dic["detail"] as? String
        self.dateText = dic["date"] as? String
    }

}
