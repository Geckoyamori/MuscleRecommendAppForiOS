//
//  MuscleStrengthRecommend.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/05.
//

import UIKit

class MuscleStrengthRecommendView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("XibView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
