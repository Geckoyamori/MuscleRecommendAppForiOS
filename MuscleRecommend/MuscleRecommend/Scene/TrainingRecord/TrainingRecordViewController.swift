//
//  TrainingRecordViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/06.
//

import UIKit

// D-003
class TrainingRecordViewController: UIViewController {
    
    // D-002からのパラメータ
    // 筋トレメニュー
    var trainingMenuName: String?
    // 筋トレメニューid
    var trainingMenuId: String?
    // 筋トレ強度
    var trainingStrength: String?
    
    // 負荷量を記録するtableView
    @IBOutlet weak var recordTableView: UITableView!
    // 負荷量を記録するtableViewのsection
    let section = ["Warm Up", "Main"]
    // tableViewに記録された負荷量を格納するディクショナリー
    var warmUpTrainingLoadRecordDic = [String: TrainingLoadRecord]()
    var mainTrainingLoadRecordDic = [String: TrainingLoadRecord]()
    
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
            // tableViewのセル内のtextFieldの入力値で負荷量Dicを更新
            recordTableView.reloadData()
        }) { (finished) in
            
        }
    }
}

// 記録された筋トレ負荷量
struct TrainingLoadRecord {
    var set: Int
    var weight: Double
    var rep: Int
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
            let trainingLoadRecord = TrainingLoadRecord(set: indexPath.row + 1, weight: Double(cell.weightTextField.text!) ?? 0, rep: Int(cell.repTextField.text!) ?? 0)
            if trainingLoadRecord.weight != 0 && trainingLoadRecord.rep != 0 {
                warmUpTrainingLoadRecordDic.updateValue(trainingLoadRecord, forKey: String(indexPath.row + 1))
            }
            return cell
        case 1:
            // 記録された負荷量をディクショナリーに格納
            let trainingLoadRecord = TrainingLoadRecord(set: indexPath.row + 1, weight: Double(cell.weightTextField.text!) ?? 0, rep: Int(cell.repTextField.text!) ?? 0)
            mainTrainingLoadRecordDic.updateValue(trainingLoadRecord, forKey: String(indexPath.row + 1))
            if trainingLoadRecord.weight != 0 && trainingLoadRecord.rep != 0 {
                warmUpTrainingLoadRecordDic.updateValue(trainingLoadRecord, forKey: String(indexPath.row + 1))
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
