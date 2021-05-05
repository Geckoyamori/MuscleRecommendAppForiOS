//
//  MuscleStrengthRecommendView.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/05.
//

import UIKit

class MuscleStrengthRecommendView: UIView {
    
    // stackView
    @IBOutlet weak var stackView: UIStackView!
    // 推奨ラベル
    @IBOutlet weak var recommendLabel: UILabel!
    // 強度ラベル
    @IBOutlet weak var strengthLabel: UILabel!
    // 推奨セットとレップ数ラベル
    @IBOutlet weak var setAndRepLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("MuscleStrengthRecommendView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        // viewの枠を角丸に設定
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
}
