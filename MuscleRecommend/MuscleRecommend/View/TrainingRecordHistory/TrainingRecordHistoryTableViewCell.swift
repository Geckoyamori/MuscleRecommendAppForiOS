//
//  TrainingRecordHistoryTableViewCell.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/08.
//

import UIKit

class TrainingRecordHistoryTableViewCell: UITableViewCell {
    // 推奨強度と負荷量
    @IBOutlet weak var recommendedStrengthLabel: UILabel!
    @IBOutlet weak var recommendedSetLabel: UILabel!
    @IBOutlet weak var recommendedWeightLabel: UILabel!
    @IBOutlet weak var recommendedRepLabel: UILabel!
    // 筋トレ記録日付
    @IBOutlet weak var trainingRecordDate: UILabel!
    // 推奨ビュー
    @IBOutlet weak var recommendView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // viewの枠を角丸に設定
        recommendView.layer.cornerRadius = 5
        recommendView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    // 推奨ラベルを非表示
//    func hideRecommendedLabel() {
//        
//    }
    
}
