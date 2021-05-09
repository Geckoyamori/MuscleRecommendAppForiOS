//
//  TrainingRecordData.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/08.
//

import Foundation
import RealmSwift

// 筋トレ記録データ
class TrainingRecordData: Object {
    // 筋トレ記録id
    @objc dynamic var trainingRecordId: String = NSUUID().uuidString
    // 筋トレメニューid
    @objc dynamic var trainingMenuId: String = NSUUID().uuidString
    // 筋トレ強度
    @objc dynamic var trainingStrength: String = ""
    // 推奨セット
    @objc dynamic var recommendedSet: Int = 0
    // 推奨重量
    @objc dynamic var recommendedWeight: Double = 0
    // 推奨回数
    @objc dynamic var recommendedRep: Int = 0
    // WarmUp筋トレ総負荷量
    @objc dynamic var totalWarmUpTrainingLoad: Double = 0
    // Main筋トレ総負荷量
    @objc dynamic var totalMainTrainingLoad: Double = 0
    // 推奨フラグ
    @objc dynamic var recommendFlag: Bool = false
    // 作成日時
    @objc dynamic var createdDate: Date = Date().toJapaneseDeviceDate()
    // 更新日時
    @objc dynamic var updatedDate: Date = Date().toJapaneseDeviceDate()
    
    // 筋トレ記録idをプライマリーキーに設定
    override class func primaryKey() -> String? {
        return "trainingRecordId"
    }
}
