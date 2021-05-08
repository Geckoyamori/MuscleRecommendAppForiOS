//
//  TrainingRecordHistoryViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/04/18.
//

import UIKit
import RealmSwift

// D-002
class TrainingRecordHistoryViewController: UIViewController {
    
    // Realm
    let realm = try! Realm()
    
    // D-001からのパラメータ
    // 筋トレメニュー
    var trainingMenuName: String?
    // 筋トレメニューid
    var trainingMenuId: String?

    // 総負荷量View
    @IBOutlet weak var highStrengthReccomendView: TrainingStrengthRecommendView!
    @IBOutlet weak var mediumStrengthReccomendView: TrainingStrengthRecommendView!
    @IBOutlet weak var lowStrengthReccomendView: TrainingStrengthRecommendView!
    // 強度の文字列
    let highStrength = "高強度"
    let mediumStrength = "中強度"
    let lowStrength = "低強度"
    let high = "High"
    let medium = "Medium"
    let low = "Low"
    // 筋トレ記録のtableView
    @IBOutlet weak var trainingRecordTableView: UITableView!
    
    // D-002のパラメータ
    // 筋トレ記録のDBの一覧取得結果
    var trainingRecordList: Results<TrainingRecordData>?
    // 直近の筋トレ記録取得結果
    var recentHighStrengthTrainingRecord: TrainingRecordData?
    var recentMediumStrengthTrainingRecord: TrainingRecordData?
    var recentLowStrengthTrainingRecord: TrainingRecordData?
    // 選択された筋トレ強度と負荷量
    var selectedTrainingStrength: String?
    var selectedRecommendedSet: Int?
    var selectedRecommendedWeight: Double?
    var selectedRecommendedRep: Int?
    

    override func viewDidLoad() {
        // navigationbarの設定
        title = trainingMenuName
        // tableViewのdelegate
        trainingRecordTableView.delegate = self
        trainingRecordTableView.dataSource = self
        // tableViewとカスタムセルとの接続
        trainingRecordTableView.register(UINib(nibName: "TrainingRecordHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "trainingRecordHistoryTableViewCell")
        
        // 筋トレメニューidに紐づく筋トレ記録を格納するリストの取得
        selectTrainingRecordList(trainingMenuId: trainingMenuId!)
        
        // 総負荷量Viewのデザイン設定
        setMuscleStrengthRecommendView()
    }
    
    // D-003で筋トレ負荷量データを保存した際に、D-002で行う処理
    override func viewWillAppear(_ animated: Bool) {
        // tableViewを更新
        trainingRecordTableView.reloadData()
        // 総負荷量の設定
        setMuscleStrengthRecommend()
    }
    
    // 総負荷量Viewのデザイン設定
    func setMuscleStrengthRecommendView() {
        // 色の設定
        highStrengthReccomendView.stackView.backgroundColor = UIColor.init(hex: "ff0000", alpha: 0.3)
        mediumStrengthReccomendView.stackView.backgroundColor = UIColor.init(hex: "ffff00", alpha: 0.3)
        lowStrengthReccomendView.stackView.backgroundColor = UIColor.init(hex: "00ffff", alpha: 0.3)
        // 強度ラベルの設定
        highStrengthReccomendView.strengthLabel.text = highStrength
        mediumStrengthReccomendView.strengthLabel.text = mediumStrength
        lowStrengthReccomendView.strengthLabel.text = lowStrength
    }
    
    // 総負荷量の設定
    func setMuscleStrengthRecommend() {
        // 強度別筋トレ総負荷量の設定
        setHighStrengthTrainingRecommend()
        setMediumStrengthTrainingRecommend()
        setLowStrengthTrainingRecommend()
    }
    
    // 高強度筋トレ総負荷量の設定
    func setHighStrengthTrainingRecommend() {
        let sortedHighStrengthTrainingRecord = trainingRecordList?.filter("trainingStrength == '\(String(describing: high))'").sorted(byKeyPath: "createdDate", ascending: false)
        if sortedHighStrengthTrainingRecord?.count == 0 {
            
        } else {
            recentHighStrengthTrainingRecord = sortedHighStrengthTrainingRecord![0]
            highStrengthReccomendView.recommendedSetLabel.text = String(5)
            highStrengthReccomendView.recommendedWeightLabel.text = String(floor(10 * recentHighStrengthTrainingRecord!.totalMainTrainingLoad / 25) / 10)
            highStrengthReccomendView.recommendedRepLabel.text = String(Int(recentHighStrengthTrainingRecord!.totalMainTrainingLoad / 5))
        }
    }
    
    // 中強度筋トレ総負荷量の設定
    func setMediumStrengthTrainingRecommend() {
        let sortedMediumStrengthTrainingRecord = trainingRecordList?.filter("trainingStrength == '\(String(describing: medium))'").sorted(byKeyPath: "createdDate", ascending: false)
        if sortedMediumStrengthTrainingRecord?.count == 0 {
            
        } else {
            recentMediumStrengthTrainingRecord = sortedMediumStrengthTrainingRecord![0]
            mediumStrengthReccomendView.recommendedSetLabel.text = String(4)
            mediumStrengthReccomendView.recommendedWeightLabel.text = String(floor(10 * recentMediumStrengthTrainingRecord!.totalMainTrainingLoad / 40) / 10)
            mediumStrengthReccomendView.recommendedRepLabel.text = String(Int(recentMediumStrengthTrainingRecord!.totalMainTrainingLoad / 10))
        }
    }
    
    // 低強度筋トレ総負荷量の設定
    func setLowStrengthTrainingRecommend() {
        let sortedLowStrengthTrainingRecord = trainingRecordList?.filter("trainingStrength == '\(String(describing: low))'").sorted(byKeyPath: "createdDate", ascending: false)
        if sortedLowStrengthTrainingRecord?.count == 0 {
            
        } else {
            recentLowStrengthTrainingRecord = sortedLowStrengthTrainingRecord![0]
            lowStrengthReccomendView.recommendedSetLabel.text = String(3)
            lowStrengthReccomendView.recommendedWeightLabel.text = String(floor(10 * recentLowStrengthTrainingRecord!.totalMainTrainingLoad / 45) / 10)
            lowStrengthReccomendView.recommendedRepLabel.text = String(Int(recentLowStrengthTrainingRecord!.totalMainTrainingLoad / 15))
        }
    }
    
    // segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTrainingRecordViewController") {
            let trainingRecordViewController: TrainingRecordViewController = segue.destination as! TrainingRecordViewController
            trainingRecordViewController.trainingMenuName = trainingMenuName
            trainingRecordViewController.trainingMenuId = trainingMenuId
            trainingRecordViewController.trainingStrength = selectedTrainingStrength
            trainingRecordViewController.recommendedSet = selectedRecommendedSet
            trainingRecordViewController.recommendedWeight = selectedRecommendedWeight
            trainingRecordViewController.recommendedRep = selectedRecommendedRep
        }
    }
    
    // 総負荷量Viewをタップ時の処理
    @IBAction func tapHighStrengthReccomendView(_ sender: Any) {
        setSelectedMuscleStrengthRecommend(strength: high, set: Int(highStrengthReccomendView.recommendedSetLabel.text!)!, weight: Double(highStrengthReccomendView.recommendedWeightLabel.text!)!, rep: Int(highStrengthReccomendView.recommendedRepLabel.text!)!)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    @IBAction func tapMediumStrengthReccomendView(_ sender: Any) {
        setSelectedMuscleStrengthRecommend(strength: medium, set: Int(mediumStrengthReccomendView.recommendedSetLabel.text!)!, weight: Double(mediumStrengthReccomendView.recommendedWeightLabel.text!)!, rep: Int(mediumStrengthReccomendView.recommendedRepLabel.text!)!)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    @IBAction func tapLowStrengthReccomendView(_ sender: Any) {
        setSelectedMuscleStrengthRecommend(strength: low, set: Int(lowStrengthReccomendView.recommendedSetLabel.text!)!, weight: Double(lowStrengthReccomendView.recommendedWeightLabel.text!)!, rep: Int(lowStrengthReccomendView.recommendedRepLabel.text!)!)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    
    // 選択された筋トレ強度と負荷量を設定
    func setSelectedMuscleStrengthRecommend(strength: String, set: Int, weight: Double, rep: Int) {
        selectedTrainingStrength = strength
        selectedRecommendedSet = set
        selectedRecommendedWeight = weight
        selectedRecommendedRep = rep
    }
}

// tableViewのメソッド
extension TrainingRecordHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    // tableViewの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingRecordList?.count ?? 0
    }
    // tableViewのセルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrainingRecordHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "trainingRecordHistoryTableViewCell", for: indexPath) as! TrainingRecordHistoryTableViewCell
        // 筋トレ強度を設定
        switch trainingRecordList?[indexPath.row].trainingStrength {
        case high:
            cell.recommendedStrengthLabel.text = highStrength
            cell.recommendView.backgroundColor = UIColor.init(hex: "ff0000", alpha: 0.3)
        case medium:
            cell.recommendedStrengthLabel.text = mediumStrength
            cell.recommendView.backgroundColor = UIColor.init(hex: "ffff00", alpha: 0.3)
        case low:
            cell.recommendedStrengthLabel.text = lowStrength
            cell.recommendView.backgroundColor = UIColor.init(hex: "00ffff", alpha: 0.3)
        default:
            break
        }
        // 筋トレ記録日付を設定
        cell.trainingRecordDate.text = Date().toStringType(date: (trainingRecordList?[indexPath.row].createdDate)!)
        // 推奨負荷量を設定
        cell.recommendedSetLabel.text = String((trainingRecordList?[indexPath.row].recommendedSet)!)
        cell.recommendedWeightLabel.text = String((trainingRecordList?[indexPath.row].recommendedWeight)!)
        cell.recommendedRepLabel.text = String((trainingRecordList?[indexPath.row].recommendedRep)!)
        return cell
    }
    // テーブルビューのセルをスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deleteTrainingRecordData(index: indexPath.row)
            trainingRecordTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
//    // テーブルビューのセル選択時の画面遷移
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        selectedTrainingMenu = trainingMenuList[indexPath.row].trainingMenuName
//        selectedTrainingMenuId = trainingMenuList[indexPath.row].trainingMenuId
//        performSegue(withIdentifier: "toTrainingRecordHistoryViewController", sender: nil)
//    }
}

// Realmのメソッド
extension TrainingRecordHistoryViewController {
    // 筋トレメニューidに紐づく筋トレ記録を格納するリストの取得
    func selectTrainingRecordList(trainingMenuId: String) {
        trainingRecordList = realm.objects(TrainingRecordData.self).filter("trainingMenuId == '\(String(describing: trainingMenuId))'").sorted(byKeyPath: "createdDate", ascending: false)
    }
    
//    // 筋トレメニューのDBに追加
//    func insertTrainingMenuData(trainingMenuName: String) {
//        // 追加する筋トレメニューの設定
//        let trainingMenuData = TrainingMenuData()
//        trainingMenuData.trainingMenuName = trainingMenuName
//        try! realm.write {
//            realm.add(TrainingMenuData(value: trainingMenuData))
//        }
//    }
//
    // 筋トレ記録のDBから削除
    func deleteTrainingRecordData(index: Int) {
        try! realm.write {
            realm.delete(trainingRecordList![index])
        }
    }
}
