//
//  MuscleRecordHistoryViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/04/18.
//

import UIKit

// D-002
class TrainingRecordHistoryViewController: UIViewController {
    // D-001からのパラメータ
    // 筋トレメニュー
    var trainingMenuName: String?
    // 筋トレメニューid
    var trainingMenuId: String?

    // 総負荷量View
    @IBOutlet weak var highStrengthReccomendView: MuscleStrengthRecommendView!
    @IBOutlet weak var mediumStrengthReccomendView: MuscleStrengthRecommendView!
    @IBOutlet weak var lowStrengthReccomendView: MuscleStrengthRecommendView!
    // 強度の文字列
    let highStrength = "高強度"
    let mediumStrength = "中強度"
    let lowStrength = "低強度"
    let high = "High"
    let medium = "Medium"
    let low = "Low"
    // 選択された筋トレ強度
    var selectedTrainingStrength: String?
    
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = trainingMenuName
        // 総負荷量Viewのデザイン設定
        setMuscleStrengthRecommendView()
        // 総負荷量の表示
        showMuscleStrengthRecommend()
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
    
    // 総負荷量の表示
    func showMuscleStrengthRecommend() {
        
    }
    
    // segueの準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMuscleRecordViewController") {
            let muscleRecordViewController: MuscleRecordViewController = segue.destination as! MuscleRecordViewController
            muscleRecordViewController.trainingMenuName = trainingMenuName
            muscleRecordViewController.trainingMenuId = trainingMenuId
            muscleRecordViewController.trainingStrength = selectedTrainingStrength
        }
    }
    
    // 総負荷量Viewをタップ時の処理
    @IBAction func tapHighStrengthReccomendView(_ sender: Any) {
        selectedTrainingStrength = high
        performSegue(withIdentifier: "toMuscleRecordViewController", sender: nil)
    }
    @IBAction func tapMediumStrengthReccomendView(_ sender: Any) {
        selectedTrainingStrength = medium
        performSegue(withIdentifier: "toMuscleRecordViewController", sender: nil)
    }
    @IBAction func tapLowStrengthReccomendView(_ sender: Any) {
        selectedTrainingStrength = low
        performSegue(withIdentifier: "toMuscleRecordViewController", sender: nil)
    }
}
