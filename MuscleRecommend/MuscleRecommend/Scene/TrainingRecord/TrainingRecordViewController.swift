//
//  TrainingRecordViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/06.
//

import UIKit
import RealmSwift

// D-003
class TrainingRecordViewController: UIViewController {
    
    // Realm
    let realm = try! Realm()
    
    // D-002からのパラメータ
    // 筋トレメニュー
    var trainingMenuName: String?
    // 筋トレメニューid
    var trainingMenuId: String?
    // 筋トレ強度
    var trainingStrength: String?
    // 推奨セット
    var recommendedSet: Int?
    // 推奨重量
    var recommendedWeight: Double?
    // 推奨回数
    var recommendedRep: Int?
    
    // 負荷量を記録するtableView
    @IBOutlet weak var recordTableView: UITableView!
    // 負荷量を記録するtableViewのsection
    let section = ["Warm Up", "Main"]
    
    // D-003のパラメータ
    // tableViewに記録された負荷量を格納するディクショナリー
    var warmUpTrainingLoadRecordDic = [String: TrainingLoadRecord]()
    var mainTrainingLoadRecordDic = [String: TrainingLoadRecord]()
    // 筋トレ記録id
    var trainingRecordId: String?
    // 総負荷量
    var totalWarmUpTrainingLoad: Double = 0
    var totalMainTrainingLoad: Double = 0
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = trainingMenuName
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        // tableViewのdelegate
        recordTableView.delegate = self
        recordTableView.dataSource = self
        // tableViewとカスタムセルとの接続
        recordTableView.register(UINib(nibName: "TrainingRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "trainingRecordTableViewCell")
        
        // textField以外をタップした際にキーボードを閉じるための処理
        setDismissKeyboard()

    }
    
    // Saveボタン押下時の処理
    @objc func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        // tableViewの非同期処理を監視
        recordTableView.performBatchUpdates({
            // tableViewのセル内のtextFieldの入力値で負荷量ディクショナリーを更新
            recordTableView.reloadData()
        }) { [self] (finished) in
            // mainにおいて、weightとrepのセットで値が埋まっているものが１つも存在しない場合エラーポップアップを表示
            if mainTrainingLoadRecordDic.count == 0 {
                // アラートダイアログを設定
                let alert = UIAlertController(
                    title: "",
                    message: "Mainセットの重量あるいは回数を入力してください。",
                    preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                // アラートダイアログを表示
                self.present(alert, animated: true, completion: nil)
            } else {
                // 筋トレ記録idの発行
                trainingRecordId = NSUUID().uuidString
                // 筋トレ負荷量のDBにupsert
                upsertWarmUpTrainingLoadData(trainingRecordId: trainingRecordId!, trainingLoadRecordDic: warmUpTrainingLoadRecordDic)
                upsertMainTrainingLoadData(trainingRecordId: trainingRecordId!, trainingLoadRecordDic: mainTrainingLoadRecordDic)
                // 筋トレ記録のDBにupsert
                upsertTrainingRecordData(trainingRecordId: trainingRecordId!, trainingMenuId: trainingMenuId!, trainingStrength: trainingStrength!, totalWarmUpTrainingLoad: totalWarmUpTrainingLoad, totalMainTrainingLoad: totalMainTrainingLoad)
                // D-002に戻る
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

// 記録された筋トレ負荷量
struct TrainingLoadRecord {
    var noOfSet: Int
    var weight: Double
    var rep: Int
    // 負荷量を記録するtableViewのsection名
    var trainingSetType: String
}

// tableViewのメソッド
extension TrainingRecordViewController: UITableViewDelegate, UITableViewDataSource {
    // tableViewの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Warm Upの場合
        case 0:
            return 5
        // Mainの場合
        case 1:
            return 10
        default:
            return 0
        }
    }
    // tableViewのセルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrainingRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "trainingRecordTableViewCell", for: indexPath) as! TrainingRecordTableViewCell
        switch indexPath.section {
        // Warm Upの場合
        case 0:
            // 推奨ラベルを非表示
            cell.hideRecommendedLabel()
            // 記録された負荷量をディクショナリーに格納
            let trainingLoadRecord = TrainingLoadRecord(noOfSet: indexPath.row + 1, weight: Double(cell.weightTextField.text!) ?? 0, rep: Int(cell.repTextField.text!) ?? 0, trainingSetType: section[indexPath.section])
            if trainingLoadRecord.weight != 0 && trainingLoadRecord.rep != 0 {
                warmUpTrainingLoadRecordDic.updateValue(trainingLoadRecord, forKey: String(indexPath.row + 1))
            }
            return cell
        // Mainの場合
        case 1:
            // 記録された負荷量をディクショナリーに格納
            let trainingLoadRecord = TrainingLoadRecord(noOfSet: indexPath.row + 1, weight: Double(cell.weightTextField.text!) ?? 0, rep: Int(cell.repTextField.text!) ?? 0, trainingSetType: section[indexPath.section])
            if trainingLoadRecord.weight != 0 && trainingLoadRecord.rep != 0 {
                mainTrainingLoadRecordDic.updateValue(trainingLoadRecord, forKey: String(indexPath.row + 1))
            }
            return cell
        default:
            return cell
        }
    }
    // section数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    // section名を設定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
}

// textField関連のメソッド
extension TrainingRecordViewController {
    // textField以外をタップした際にキーボードを閉じるための処理
    func setDismissKeyboard() {
        // タップ認識するためのインスタンスを生成
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        // Viewに追加
        view.addGestureRecognizer(tapGesture)
    }
    
    // キーボードと閉じる際の処理
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Realmのメソッド
extension TrainingRecordViewController {
    // 筋トレ記録のDBにupsert
    func upsertTrainingRecordData(trainingRecordId: String, trainingMenuId: String, trainingStrength: String, totalWarmUpTrainingLoad: Double, totalMainTrainingLoad: Double) {
        // 追加する筋トレ記録の設定
        let trainingRecordData = TrainingRecordData()
        trainingRecordData.trainingRecordId = trainingRecordId
        trainingRecordData.trainingMenuId = trainingMenuId
        trainingRecordData.trainingStrength = trainingStrength
        trainingRecordData.totalWarmUpTrainingLoad = totalWarmUpTrainingLoad
        trainingRecordData.totalMainTrainingLoad = totalMainTrainingLoad
        trainingRecordData.recommendedSet = recommendedSet!
        trainingRecordData.recommendedWeight = recommendedWeight!
        trainingRecordData.recommendedRep = recommendedRep!
        try! realm.write {
            realm.add(TrainingRecordData(value: trainingRecordData), update: .all)
        }
    }
    
    // Warm Up筋トレ負荷量のDBにupsert
    func upsertWarmUpTrainingLoadData(trainingRecordId: String, trainingLoadRecordDic: [String: TrainingLoadRecord]) {
        for trainingLoadRecord in trainingLoadRecordDic {
            // 追加する筋トレ負荷量の設定
            let trainingLoadData = TrainingLoadData()
            trainingLoadData.trainingRecordId = trainingRecordId
            trainingLoadData.trainingSetType = trainingLoadRecord.value.trainingSetType
            trainingLoadData.noOfSet = trainingLoadRecord.value.noOfSet
            trainingLoadData.weight = trainingLoadRecord.value.weight
            trainingLoadData.rep = trainingLoadRecord.value.rep
            try! realm.write {
                realm.add(TrainingLoadData(value: trainingLoadData), update: .all)
            }
            // 総負荷量の算出
            totalWarmUpTrainingLoad += trainingLoadRecord.value.weight * Double(trainingLoadRecord.value.rep)
        }
    }
    
    // Main筋トレ負荷量のDBにupsert
    func upsertMainTrainingLoadData(trainingRecordId: String, trainingLoadRecordDic: [String: TrainingLoadRecord]) {
        for trainingLoadRecord in trainingLoadRecordDic {
            // 追加する筋トレ負荷量の設定
            let trainingLoadData = TrainingLoadData()
            trainingLoadData.trainingRecordId = trainingRecordId
            trainingLoadData.trainingSetType = trainingLoadRecord.value.trainingSetType
            trainingLoadData.noOfSet = trainingLoadRecord.value.noOfSet
            trainingLoadData.weight = trainingLoadRecord.value.weight
            trainingLoadData.rep = trainingLoadRecord.value.rep
            try! realm.write {
                realm.add(TrainingLoadData(value: trainingLoadData), update: .all)
            }
            // 総負荷量の算出
            totalMainTrainingLoad += trainingLoadRecord.value.weight * Double(trainingLoadRecord.value.rep)
        }
    }
    
//    // 筋トレメニューのDBから削除
//    func deleteTrainingMenuData(index: Int) {
//        try! realm.write {
//            realm.delete(trainingMenuList[index])
//        }
//    }
}
