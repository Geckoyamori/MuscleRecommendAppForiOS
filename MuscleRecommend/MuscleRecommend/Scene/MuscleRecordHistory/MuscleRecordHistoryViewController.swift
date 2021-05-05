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
    @IBOutlet weak var highStrengthReccomendView: MuscleStrengthRecommendView!
    @IBOutlet weak var mediumStrengthReccomendView: MuscleStrengthRecommendView!
    @IBOutlet weak var lowStrengthReccomendView: MuscleStrengthRecommendView!
    // 強度の文字列
    let highStrength = "高強度"
    let mediumStrength = "中強度"
    let lowStrength = "低強度"
    
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = navigationBarTitle
        // 推奨セット・レップ数のViewのデザイン設定
        setMuscleStrengthRecommendView()
        // 推奨セット・レップ数の表示
        showMuscleStrengthRecommend()
    }
    
    // 推奨セット・レップ数のViewのデザイン設定
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
    
    // 推奨セット・レップ数の表示
    func showMuscleStrengthRecommend() {
        
    }
}
