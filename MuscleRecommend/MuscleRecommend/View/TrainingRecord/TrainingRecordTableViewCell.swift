//
//  TrainingRecordTableViewCell.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/07.
//

import UIKit

class TrainingRecordTableViewCell: UITableViewCell, UITextFieldDelegate {
    // 推奨ラベル
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var recommendedStringKgLabel: UILabel!
    @IBOutlet weak var recommendedStringRepLabel: UILabel!
    // 推奨重量ラベル
    @IBOutlet weak var recommendedWeightLabel: UILabel!
    // 推奨回数ラベル
    @IBOutlet weak var recommendedRepLabel: UILabel!
    // 重量入力テキストフィールド
    @IBOutlet weak var weightTextField: UITextField! {
        didSet {
            weightTextField.keyboardType = .decimalPad
        }
    }
    // 回数入力テキストフィールド
    @IBOutlet weak var repTextField: UITextField! {
        didSet {
            repTextField.keyboardType = .numberPad
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // textFieldのdelegateを設定
        weightTextField.delegate = self
        repTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // キーボードのDoneボタン押下でキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 推奨ラベルを非表示
    func hideRecommendedLabel() {
        recommendedLabel.isHidden = true
        recommendedStringKgLabel.isHidden = true
        recommendedStringRepLabel.isHidden = true
        recommendedWeightLabel.isHidden = true
        recommendedRepLabel.isHidden = true
    }
    
}
