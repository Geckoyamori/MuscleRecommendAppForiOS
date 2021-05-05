//
//  MuscleRecordHistoryViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/04/18.
//

import UIKit

class MuscleRecordHistoryViewController: UIViewController {
    // navigationbarのタイトル
    var navigationBarTitle = ""
    // 推奨セット・レップ数のView
    @IBOutlet weak var highStrengthReccomend: MuscleStrengthRecommendView!
    @IBOutlet weak var mediumStrengthReccomend: MuscleStrengthRecommendView!
    @IBOutlet weak var lowStrengthReccomend: MuscleStrengthRecommendView!
    // 強度の文字列
    let highStrength = "高強度"
    let mediumStrength = "中強度"
    let lowStrength = "低強度"
    
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = navigationBarTitle
        // 推奨セット・レップ数の表示
        showMuscleStrengthRecommend()
    }
    
    // 推奨セット・レップ数の表示
    func showMuscleStrengthRecommend() {
        // 強度ラベルの設定
        highStrengthReccomend.strengthLabel.text = highStrength
        mediumStrengthReccomend.strengthLabel.text = mediumStrength
        lowStrengthReccomend.strengthLabel.text = lowStrength
        
        
    }
}
