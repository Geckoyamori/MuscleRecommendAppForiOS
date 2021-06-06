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
    
    // 筋トレ記録モデル
    let trainingRecordModel = TrainingRecordModel()
    
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
    let highStrengthDescription = "初回の高強度トレーニングを記録後に、\n次回以降の推奨メニューが表示されます。"
    let mediumStrengthDescription = "初回の中強度トレーニングを記録後に、\n次回以降の推奨メニューが表示されます。"
    let lowStrengthDescription = "初回の低強度トレーニングを記録後に、\n次回以降の推奨メニューが表示されます。"
    // 筋トレ記録のtableView
    @IBOutlet weak var trainingRecordTableView: UITableView! {
        didSet {
            // tableViewのdelegate
            trainingRecordTableView.delegate = self
            trainingRecordTableView.dataSource = self
            // tableViewとカスタムセルとの接続
            trainingRecordTableView.register(UINib(nibName: "TrainingRecordHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "trainingRecordHistoryTableViewCell")
        }
    }
    
    // D-002のパラメータ
    // 筋トレ記録id
    var trainingRecordId: String?
    // 筋トレ記録のDBの一覧取得結果
    var trainingRecordList: Results<TrainingRecordData>?
    // 直近の筋トレ記録取得結果
    var recentHighStrengthTrainingRecord: TrainingRecordData?
    var recentMediumStrengthTrainingRecord: TrainingRecordData?
    var recentLowStrengthTrainingRecord: TrainingRecordData?
    // 選択された筋トレ強度と負荷量
    var trainingStrength: String?
    var recommendedSet: Int?
    var recommendedWeight: Double?
    var recommendedRep: Int?
    // 筋トレ記録が①推奨新規登録or編集登録か②完全新規登録を判定するフラグ
    var recommendFlag: Bool = false
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = trainingMenuName
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addBarButtonItem
        
        // 筋トレメニューidに紐づく筋トレ記録を格納するリストの取得
        trainingRecordList = trainingRecordModel.selectTrainingRecordList(trainingMenuId: trainingMenuId!)
        
        // 総負荷量Viewのデザイン設定
        setMuscleStrengthRecommendView()
    }
    
    // D-003で筋トレ負荷量データを保存した際に、D-002で行う処理
    override func viewWillAppear(_ animated: Bool) {
        // パラメータの初期化
        trainingRecordId = nil
        trainingStrength = nil
        recommendedSet = nil
        recommendedWeight = nil
        recommendedRep = nil
        recommendFlag = false
        // tableViewを更新
        trainingRecordTableView.reloadData()
        // 総負荷量の設定
        setMuscleStrengthRecommend()
    }
    
    // Addボタン押下時の処理
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
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
        let sortedHighStrengthTrainingRecord = trainingRecordModel.selectTrainingRecordListByStrength(trainingMenuId: trainingMenuId!, strength: highStrength)
        // 高強度筋トレを一度も記録したことがない場合は、総負荷量Viewをグレーアウト
        if sortedHighStrengthTrainingRecord?.count == 0 {
            setGrayView(strengthReccomendView: highStrengthReccomendView, strengthDescription: highStrengthDescription)
        } else {
            // グレーアウトを解除
            removeGrayView(strengthReccomendView: highStrengthReccomendView)
            highStrengthReccomendView.grayView.isHidden = true
            recentHighStrengthTrainingRecord = sortedHighStrengthTrainingRecord![0]
            highStrengthReccomendView.recommendedSetLabel.text = String(5)
            highStrengthReccomendView.recommendedWeightLabel.text = String(floor(10 * recentHighStrengthTrainingRecord!.totalMainTrainingLoad / 25) / 10)
            highStrengthReccomendView.recommendedRepLabel.text = String(Int(recentHighStrengthTrainingRecord!.totalMainTrainingLoad / 5))
        }
    }
    
    // 中強度筋トレ総負荷量の設定
    func setMediumStrengthTrainingRecommend() {
        let sortedMediumStrengthTrainingRecord = trainingRecordModel.selectTrainingRecordListByStrength(trainingMenuId: trainingMenuId!, strength: mediumStrength)
        // 中強度筋トレを一度も記録したことがない場合は、総負荷量Viewをグレーアウト
        if sortedMediumStrengthTrainingRecord?.count == 0 {
            setGrayView(strengthReccomendView: mediumStrengthReccomendView, strengthDescription: mediumStrengthDescription)
        } else {
            // グレーアウトを解除
            removeGrayView(strengthReccomendView: mediumStrengthReccomendView)
            recentMediumStrengthTrainingRecord = sortedMediumStrengthTrainingRecord![0]
            mediumStrengthReccomendView.recommendedSetLabel.text = String(4)
            mediumStrengthReccomendView.recommendedWeightLabel.text = String(floor(10 * recentMediumStrengthTrainingRecord!.totalMainTrainingLoad / 40) / 10)
            mediumStrengthReccomendView.recommendedRepLabel.text = String(Int(recentMediumStrengthTrainingRecord!.totalMainTrainingLoad / 10))
        }
    }
    
    // 低強度筋トレ総負荷量の設定
    func setLowStrengthTrainingRecommend() {
        let sortedLowStrengthTrainingRecord = trainingRecordModel.selectTrainingRecordListByStrength(trainingMenuId: trainingMenuId!, strength: lowStrength)
        // 低強度筋トレを一度も記録したことがない場合は、総負荷量Viewをグレーアウト
        if sortedLowStrengthTrainingRecord?.count == 0 {
            setGrayView(strengthReccomendView: lowStrengthReccomendView, strengthDescription: lowStrengthDescription)
        } else {
            // グレーアウトを解除
            removeGrayView(strengthReccomendView: lowStrengthReccomendView)
            lowStrengthReccomendView.grayView.isHidden = true
            recentLowStrengthTrainingRecord = sortedLowStrengthTrainingRecord![0]
            lowStrengthReccomendView.recommendedSetLabel.text = String(3)
            lowStrengthReccomendView.recommendedWeightLabel.text = String(floor(10 * recentLowStrengthTrainingRecord!.totalMainTrainingLoad / 45) / 10)
            lowStrengthReccomendView.recommendedRepLabel.text = String(Int(recentLowStrengthTrainingRecord!.totalMainTrainingLoad / 15))
        }
    }
    
    // 総負荷量Viewをグレーアウト
    func setGrayView(strengthReccomendView: TrainingStrengthRecommendView, strengthDescription: String) {
        strengthReccomendView.grayView.isHidden = false
        strengthReccomendView.isUserInteractionEnabled = false
        strengthReccomendView.grayViewLabel.text = strengthDescription
    }
    
    // 総負荷量Viewのグレーアウトを解除
    func removeGrayView(strengthReccomendView: TrainingStrengthRecommendView) {
        strengthReccomendView.grayView.isHidden = true
        strengthReccomendView.isUserInteractionEnabled = true
    }
    
    // segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTrainingRecordViewController") {
            let trainingRecordViewController: TrainingRecordViewController = segue.destination as! TrainingRecordViewController
            trainingRecordViewController.trainingRecordId = self.trainingRecordId
            trainingRecordViewController.trainingMenuName = self.trainingMenuName
            trainingRecordViewController.trainingMenuId = self.trainingMenuId
            trainingRecordViewController.trainingStrength = self.trainingStrength
            trainingRecordViewController.recommendedSet = self.recommendedSet
            trainingRecordViewController.recommendedWeight = self.recommendedWeight
            trainingRecordViewController.recommendedRep = self.recommendedRep
            trainingRecordViewController.recommendFlag = self.recommendFlag
        }
    }
    
    // 総負荷量Viewをタップ時の処理
    @IBAction func tapHighStrengthReccomendView(_ sender: Any) {
        setSelectedMuscleStrengthRecommend(strength: highStrength, set: Int(highStrengthReccomendView.recommendedSetLabel.text!)!, weight: Double(highStrengthReccomendView.recommendedWeightLabel.text!)!, rep: Int(highStrengthReccomendView.recommendedRepLabel.text!)!, recommendFlag: true)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    @IBAction func tapMediumStrengthReccomendView(_ sender: Any) {
        setSelectedMuscleStrengthRecommend(strength: mediumStrength, set: Int(mediumStrengthReccomendView.recommendedSetLabel.text!)!, weight: Double(mediumStrengthReccomendView.recommendedWeightLabel.text!)!, rep: Int(mediumStrengthReccomendView.recommendedRepLabel.text!)!, recommendFlag: true)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    @IBAction func tapLowStrengthReccomendView(_ sender: Any) {
        setSelectedMuscleStrengthRecommend(strength: lowStrength, set: Int(lowStrengthReccomendView.recommendedSetLabel.text!)!, weight: Double(lowStrengthReccomendView.recommendedWeightLabel.text!)!, rep: Int(lowStrengthReccomendView.recommendedRepLabel.text!)!, recommendFlag: true)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    
    // 選択された総負荷量Viewの筋トレ強度と負荷量を設定
    func setSelectedMuscleStrengthRecommend(strength: String, set: Int, weight: Double, rep: Int, recommendFlag: Bool) {
        self.trainingStrength = strength
        self.recommendedSet = set
        self.recommendedWeight = weight
        self.recommendedRep = rep
        self.recommendFlag = recommendFlag
        // 総負荷量Viewをタップ時は、筋トレ記録idはnil
        self.trainingRecordId = nil
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
        case highStrength:
            cell.recommendedStrengthLabel.text = highStrength
            cell.recommendView.backgroundColor = UIColor.init(hex: "ff0000", alpha: 0.3)
        case mediumStrength:
            cell.recommendedStrengthLabel.text = mediumStrength
            cell.recommendView.backgroundColor = UIColor.init(hex: "ffff00", alpha: 0.3)
        case lowStrength:
            cell.recommendedStrengthLabel.text = lowStrength
            cell.recommendView.backgroundColor = UIColor.init(hex: "00ffff", alpha: 0.3)
        default:
            break
        }
        // 筋トレ記録日付を設定
        cell.trainingRecordDate.text = Date().toStringType(date: (trainingRecordList?[indexPath.row].createdDate)!)
//        // 推奨負荷量Viewから遷移した筋トレ記録
//        if trainingRecordList?[indexPath.row].recommendedSet == 0 {
//            cell.hideRecommendedLabel()
//        }
        // 推奨負荷量を設定
        cell.recommendedSetLabel.text = String((trainingRecordList?[indexPath.row].recommendedSet)!)
        cell.recommendedWeightLabel.text = String((trainingRecordList?[indexPath.row].recommendedWeight)!)
        cell.recommendedRepLabel.text = String((trainingRecordList?[indexPath.row].recommendedRep)!)
        return cell
    }
    // テーブルビューのセルをスワイプで削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            trainingRecordModel.deleteTrainingRecordData(trainingRecordList: trainingRecordList!, index: indexPath.row)
            trainingRecordTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    // テーブルビューのセル選択時の画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setSelectedTrainingRecord(trainingRecordId: trainingRecordList![indexPath.row].trainingRecordId, strength: trainingRecordList![indexPath.row].trainingStrength, set: trainingRecordList![indexPath.row].recommendedSet, weight: trainingRecordList![indexPath.row].recommendedWeight, rep: trainingRecordList![indexPath.row].recommendedRep, recommendFlag: true)
        performSegue(withIdentifier: "toTrainingRecordViewController", sender: nil)
    }
    
    // 選択された筋トレ記録の筋トレ強度と負荷量を設定
    func setSelectedTrainingRecord(trainingRecordId: String, strength: String, set: Int, weight: Double, rep: Int, recommendFlag: Bool) {
        self.trainingStrength = strength
        self.recommendedSet = set
        self.recommendedWeight = weight
        self.recommendedRep = rep
        self.recommendFlag = recommendFlag
        self.trainingRecordId = trainingRecordId
    }
}
