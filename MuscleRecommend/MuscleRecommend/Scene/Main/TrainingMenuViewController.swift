//
//  TrainingMenuViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/01/10.
//

import UIKit
import RealmSwift

// D-001
class TrainingMenuViewController: UIViewController {
    // Realm
    let realm = try! Realm()
    // navigationbarのタイトル
    let navigationBarTitle = "筋トレメニュー"
    // 筋トレメニューのDBの一覧取得結果
    var trainingMenuList: Results<TrainingMenuData>!
    // 選択された筋トレメニュー
    var selectedTrainingMenu: String?
    // 選択された筋トレメニューid
    var selectedTrainingMenuId: String?
    // 筋トレメニューを表示するtableView
    @IBOutlet weak var muscleMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // realmの中身確認用コード
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // navigationbarの設定
        title = navigationBarTitle
        
        // tableViewのdelegate
        muscleMenuTableView.delegate = self
        muscleMenuTableView.dataSource = self

        // 筋トレメニューを格納するリストの取得
        trainingMenuList = realm.objects(TrainingMenuData.self)
    }
    
    // segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTrainingRecordHistoryViewController") {
        let trainingRecordHistoryViewController: TrainingRecordHistoryViewController = segue.destination as! TrainingRecordHistoryViewController
            trainingRecordHistoryViewController.trainingMenuName = selectedTrainingMenu!
            trainingRecordHistoryViewController.trainingMenuId = selectedTrainingMenuId!
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
                insertTrainingMenuData(trainingMenuName: textField.text!)
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
extension TrainingMenuViewController: UITableViewDelegate, UITableViewDataSource {
    // tableViewの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingMenuList.count
    }
    // tableViewのセルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel!.text = trainingMenuList[indexPath.row].trainingMenuName
        return cell
    }
    // テーブルビューのセルをスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deleteTrainingMenuData(index: indexPath.row)
            muscleMenuTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }    
    // テーブルビューのセル選択時の画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTrainingMenu = trainingMenuList[indexPath.row].trainingMenuName
        selectedTrainingMenuId = trainingMenuList[indexPath.row].trainingMenuId
        performSegue(withIdentifier: "toTrainingRecordHistoryViewController", sender: nil)
    }
}

// Realmのメソッド
extension TrainingMenuViewController {
    // 筋トレメニューのDBに追加
    func insertTrainingMenuData(trainingMenuName: String) {
        // 追加する筋トレメニューの設定
        let trainingMenuData = TrainingMenuData()
        trainingMenuData.trainingMenuName = trainingMenuName
        try! realm.write {
            realm.add(TrainingMenuData(value: trainingMenuData))
        }
    }
    
    // 筋トレメニューのDBから削除
    func deleteTrainingMenuData(index: Int) {
        try! realm.write {
            realm.delete(trainingMenuList[index])
        }
    }
}
