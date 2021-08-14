//
//  TrainingStrengthRecommendView.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/05.
//

import UIKit

class TrainingStrengthRecommendView: UIView {
    
    // grayView
    @IBOutlet weak var grayView: UIView! {
        didSet {
            grayView.isHidden = true
            grayView.backgroundColor = UIColor.init(hex: "c0c0c0", alpha: 1.0)
        }
    }
    // grayView上のラベル
    @IBOutlet weak var grayViewLabel: UILabel!
    // stackView
    @IBOutlet weak var stackView: UIStackView!
    // 推奨ラベル
    @IBOutlet weak var recommendLabel: UILabel!
    // 強度ラベル
    @IBOutlet weak var strengthLabel: UILabel!
    // 推奨負荷量ラベル
    @IBOutlet weak var recommendedSetLabel: UILabel!
    @IBOutlet weak var recommendedWeightLabel: UILabel!
    @IBOutlet weak var recommendedRepLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("TrainingStrengthRecommendView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        // viewの枠を角丸に設定
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
}
