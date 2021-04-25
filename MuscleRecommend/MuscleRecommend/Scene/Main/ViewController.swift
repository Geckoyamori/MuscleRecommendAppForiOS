//
//  ViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/01/10.
//

import UIKit

class ViewController: UIViewController {
    // navigationbarのタイトル
    let navigationBarTitle = "筋トレメニュー"
    // 筋トレメニューを格納するリスト
    var muscleMenuList = [String]()
    // 選択された筋トレメニュー
    var selectedMuscleMenu: String?
    // 筋トレメニューを表示するtableView
    @IBOutlet weak var muscleMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationbarの設定
        title = navigationBarTitle
        
        muscleMenuTableView.delegate = self
        muscleMenuTableView.dataSource = self
        
        // 筋トレメニューを格納するリストをUserDefaultsから取得
        if UserDefaults.standard.object(forKey: "muscleMenuList") != nil {
            muscleMenuList = UserDefaults.standard.object(forKey: "muscleMenuList") as! [String]
        }
    }
    
    // segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMuscleRecordHistoryViewController") {
            let muscleRecordHistoryViewController: MuscleRecordHistoryViewController = segue.destination as! MuscleRecordHistoryViewController
            muscleRecordHistoryViewController.navigationBarTitle = selectedMuscleMenu!
        }
    }
    
    // navigationbarの追加ボタンをタップした場合の処理
    @IBAction func tapAddButton(_ sender: Any) {
        // 筋トレメニュー追加のアラートダイアログを表示
        showAddMuscleMenuDialog()
    }
    
    // 筋トレメニュー追加のアラートダイアログを表示
    func showAddMuscleMenuDialog() {
        // アラートダイアログを定義
        let alert = UIAlertController(
            title: "筋トレメニューの追加",
            message: "追加する筋トレメニューを入力してください。",
            preferredStyle: UIAlertController.Style.alert)
        // Cancel, OKボタンを定義
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] (_) in
            if let textField = alert.textFields?.first {
                muscleMenuList.append(textField.text!)
                UserDefaults.standard.set(muscleMenuList, forKey: "muscleMenuList")
            }
            muscleMenuTableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        okAction.isEnabled = false
        // アラートダイアログにテキストフィールドを定義
        alert.addTextField{(textField) in
            // textFieldが空白の時はOKボタンを非活性化
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {_ in
                let textCount = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count
                okAction.isEnabled = textCount > 0
            })
        }
        // アラートダイアログを表示
        self.present(alert, animated: true, completion: nil)
    }

}

// tableViewのメソッド
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
            UserDefaults.standard.set(muscleMenuList, forKey: "muscleMenuList")
            muscleMenuTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }    
    // テーブルビューのセル選択時の画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMuscleMenu = muscleMenuList[indexPath.row]
        performSegue(withIdentifier: "toMuscleRecordHistoryViewController", sender: nil)
    }
}
