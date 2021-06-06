//
//  TrainingRecordTableViewHeaderView.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/23.
//

import UIKit

protocol TrainingRecordTableViewHeaderViewDelegate: class {
    // セットを追加する処理
    func addSet(sectionNumber: Int)
}

class TrainingRecordTableViewHeaderView: UITableViewHeaderFooterView {
    
    // delegate
    var trainingRecordTableViewHeaderViewDelegate: TrainingRecordTableViewHeaderViewDelegate?
    
    // セクション名
    @IBOutlet weak var sectionLabel: UILabel!
    // セット追加ボタン
    @IBOutlet weak var addSetButton: UIButton!
    // セット追加ボタン押下時の処理
    @IBAction func tapAddSetButton(_ sender: Any) {
        // セットを追加する
        trainingRecordTableViewHeaderViewDelegate?.addSet(sectionNumber: (sender as AnyObject).tag)
    }
    
    // ヘッダーのデザインをセットアップ
    func setUp(sectionNumber: Int, sectionName: String) {
        addSetButton.tag = sectionNumber
        sectionLabel.text = sectionName
    }
}
