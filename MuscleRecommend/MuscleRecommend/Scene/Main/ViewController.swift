//
//  ViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/01/10.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // navigationbarのタイトル
    let navigationBarTitle = "筋トレメニュー"
    // 筋トレメニューを格納するリスト
    var muscleMenuList = [String]()
    // 筋トレメニューを表示するtableView
    @IBOutlet weak var muscleMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationbarの設定
        title = navigationBarTitle
        
        // 筋トレメニューを格納するリストをUserDefaultsから取得
        if UserDefaults.standard.object(forKey: "muscleMenuList") != nil {
            muscleMenuList = UserDefaults.standard.object(forKey: "muscleMenuList") as! [String]
        }
    }
    
    // tableViewの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscleMenuList.count
    }
    // tableViewのセルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel!.text = muscleMenuList[indexPath.row]
        return cell
    }
    // テーブルビューのセルをスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            muscleMenuList.remove(at: indexPath.row)
            muscleMenuTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // navigationbarの追加ボタンをタップした場合の処理
    @IBAction func tapAddButton(_ sender: Any) {
        // アラートダイアログを定義
        let alert = UIAlertController(
            title: "筋トレメニューの追加",
            message: "追加する筋トレメニューを入力してください。",
            preferredStyle: UIAlertController.Style.alert)
        // アラートダイアログにテキストフィールドを定義
        alert.addTextField(configurationHandler: nil)
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { [self] _ in
                if let textField = alert.textFields?.first {
                    muscleMenuList.append(textField.text!)
                    UserDefaults.standard.set(muscleMenuList, forKey: "muscleMenuList")
                }
                muscleMenuTableView.reloadData()
            }
        )
        // アラートダイアログを表示
        self.present(alert, animated: true, completion: nil)
    }

}

