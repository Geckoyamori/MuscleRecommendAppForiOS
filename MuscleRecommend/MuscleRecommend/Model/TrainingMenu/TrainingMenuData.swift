//
//  TrainingMenuData.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/04/25.
//

import UIKit
import RealmSwift

// 筋トレメニューデータ
class TrainingMenuData: Object {
    // 筋トレメニューid
    @objc dynamic var trainingMenuId: String = NSUUID().uuidString
    // 筋トレメニュー名
    @objc dynamic var trainingMenuName: String = ""
    // 筋トレ部位
    @objc dynamic var trainingPart: String = ""
    // 作成日時
    @objc dynamic var createdDate: Date = Date().toJapaneseDeviceDate()
    // 更新日時
    @objc dynamic var updatedDate: Date = Date().toJapaneseDeviceDate()
    
    // 筋トレメニューidをプライマリーキーに設定
    override class func primaryKey() -> String? {
        return "trainingMenuId"
    }
}
