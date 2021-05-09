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
    
    // 筋トレ負荷量モデル
    let trainingLoadModel = TrainingLoadModel()
    
    // D-002からのパラメータ
    // 筋トレ記録id
    var trainingRecordId: String?
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
    // 総負荷量Viewからの遷移かどうかを判定するフラグ
    var recommendFlag: Bool?
    
    // 負荷量を記録するtableView
    @IBOutlet weak var recordTableView: UITableView!
    // 負荷量を記録するtableViewのsection
    let section = ["Warm Up", "Main"]
    // 強度を選択するpickerView
    @IBOutlet weak var strengthPickerView: UIPickerView!
    // pickerViewの配列
    let strengthPickerArray = ["高強度", "中強度", "低強度"]
    
    // D-003のパラメータ
    // 筋トレ負荷量のDBの一覧取得結果
    var warmUpTrainingLoadList: Results<TrainingLoadData>?
    var mainTrainingLoadList: Results<TrainingLoadData>?
    // 筋トレ記録のDB取得結果
    var targetTrainingRecord: Results<TrainingRecordData>?
    // tableViewに記録された負荷量を格納するディクショナリー
    var warmUpTrainingLoadRecordDic = [String: TrainingLoadRecord]()
    var mainTrainingLoadRecordDic = [String: TrainingLoadRecord]()
    // 総負荷量
    var totalWarmUpTrainingLoad: Double = 0
    var totalMainTrainingLoad: Double = 0
    // saveボタン押下フラグ
    var saveButtonFlag: Bool = false
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = trainingMenuName
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        // 初期化
        trainingStrength = "中強度"
        
        // tableViewのdelegate
        recordTableView.delegate = self
        recordTableView.dataSource = self
        // tableViewとカスタムセルとの接続
        recordTableView.register(UINib(nibName: "TrainingRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "trainingRecordTableViewCell")
        // pickerViewのdelegate
        strengthPickerView.delegate = self
        strengthPickerView.dataSource = self
        
        // textField以外をタップした際にキーボードを閉じるための処理
        setDismissKeyboard()
        
        // 編集登録の場合
        if trainingRecordId != nil {
            // 筋トレ記録idとセット種類に紐づく筋トレ負荷量リストの取得
            warmUpTrainingLoadList = trainingLoadModel.selectTrainingLoadList(trainingRecordId: trainingRecordId!, setType: section[0])
            mainTrainingLoadList = trainingLoadModel.selectTrainingLoadList(trainingRecordId: trainingRecordId!, setType: section[1])
            // 筋トレ記録idに紐づく筋トレ記録の取得
            targetTrainingRecord = trainingLoadModel.selectTargetTrainingRecord(trainingRecordId: trainingRecordId!)
        }
    }
    
    // Saveボタン押下時の処理
    @objc func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        // tableViewの非同期処理を監視
        recordTableView.performBatchUpdates({
            // saveボタン押下フラグ
            saveButtonFlag = true
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
                // 新規登録の場合
                if trainingRecordId == nil {
                    // 筋トレ記録idの発行
                    trainingRecordId = NSUUID().uuidString
                    // 入力した筋トレ負荷量データを筋トレ負荷量テーブルに追加して、総負荷量も算出
                    totalWarmUpTrainingLoad = trainingLoadModel.insertTrainingLoadData(trainingRecordId: trainingRecordId!, trainingLoadRecordDic: warmUpTrainingLoadRecordDic)
                    totalMainTrainingLoad = trainingLoadModel.insertTrainingLoadData(trainingRecordId: trainingRecordId!, trainingLoadRecordDic: mainTrainingLoadRecordDic)
                    // 筋トレ記録テーブルにinsert
                    let trainingRecordData = TrainingRecordData()
                    trainingRecordData.trainingRecordId = trainingRecordId!
                    trainingRecordData.trainingMenuId = trainingMenuId!
                    trainingRecordData.trainingStrength = trainingStrength!
                    trainingRecordData.totalWarmUpTrainingLoad = totalWarmUpTrainingLoad
                    trainingRecordData.totalMainTrainingLoad = totalMainTrainingLoad
                    trainingRecordData.recommendedSet = recommendedSet ?? 0
                    trainingRecordData.recommendedWeight = recommendedWeight ?? 0
                    trainingRecordData.recommendedRep = recommendedRep ?? 0
                    trainingRecordData.recommendFlag = recommendFlag!
                    trainingLoadModel.insertTrainingRecordData(trainingRecordData: trainingRecordData)
                    
                // 編集登録の場合
                } else {
                    // 入力した筋トレ負荷量データを更新して、総負荷量も算出
                    totalWarmUpTrainingLoad = trainingLoadModel.updateTrainingLoadData(trainingLoadRecordDic: warmUpTrainingLoadRecordDic)
                    totalMainTrainingLoad = trainingLoadModel.updateTrainingLoadData(trainingLoadRecordDic: mainTrainingLoadRecordDic)
                    // 筋トレ記録をupdate
                    trainingLoadModel.updateTrainingRecordData(trainingRecordId: trainingRecordId!, totalWarmUpTrainingLoad: totalWarmUpTrainingLoad, totalMainTrainingLoad: totalMainTrainingLoad)
                }
           
                // D-002に戻る
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

// tableViewのメソッド
extension TrainingRecordViewController: UITableViewDelegate, UITableViewDataSource {
    // tableViewの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Warm Upの場合
        case 0:
            // 新祈登録の場合
            if trainingRecordId == nil {
                return 5
            }
            return warmUpTrainingLoadList!.count
        // Mainの場合
        case 1:
            // 新祈登録の場合
            if trainingRecordId == nil {
                return 7
            }
            return mainTrainingLoadList!.count
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
            // 編集登録の初期表示の場合、編集前の記録をセットする
            if trainingRecordId != nil && !saveButtonFlag {
                cell.weightTextField.text = String(warmUpTrainingLoadList![indexPath.row].weight)
                cell.repTextField.text = String(warmUpTrainingLoadList![indexPath.row].rep)
            }
            // 記録された負荷量をディクショナリーに格納
            let trainingLoadRecord = TrainingLoadRecord(trainingLoadId: warmUpTrainingLoadList?[indexPath.row].trainingLoadId ?? "0", noOfSet: indexPath.row + 1, weight: Double(cell.weightTextField.text!) ?? 0, rep: Int(cell.repTextField.text!) ?? 0, trainingSetType: section[indexPath.section])
            if trainingLoadRecord.weight != 0 && trainingLoadRecord.rep != 0 {
                warmUpTrainingLoadRecordDic.updateValue(trainingLoadRecord, forKey: String(indexPath.row + 1))
            }
            return cell
        // Mainの場合
        case 1:
            // 編集登録の場合、編集前の記録をセットする
            if trainingRecordId != nil && !saveButtonFlag {
                cell.weightTextField.text = String(mainTrainingLoadList![indexPath.row].weight)
                cell.repTextField.text = String(mainTrainingLoadList![indexPath.row].rep)
            }
            // 記録された負荷量をディクショナリーに格納
            let trainingLoadRecord = TrainingLoadRecord(trainingLoadId: mainTrainingLoadList?[indexPath.row].trainingLoadId ?? "0", noOfSet: indexPath.row + 1, weight: Double(cell.weightTextField.text!) ?? 0, rep: Int(cell.repTextField.text!) ?? 0, trainingSetType: section[indexPath.section])
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

// pickerViewのメソッド
extension TrainingRecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strengthPickerArray.count
    }
     
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return strengthPickerArray[row]
    }
     
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        trainingStrength = strengthPickerArray[row]
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

// 記録された筋トレ負荷量
struct TrainingLoadRecord {
    var trainingLoadId: String
    var noOfSet: Int
    var weight: Double
    var rep: Int
    // 負荷量を記録するtableViewのsection名
    var trainingSetType: String
}
