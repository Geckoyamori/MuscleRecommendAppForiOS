//
//  MuscleMenuData.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/04/25.
//

import UIKit
import RealmSwift

class MuscleMenuData: Object {
    // 筋トレメニューid
    dynamic var trainingMenuId: String = NSUUID().uuidString
    // 筋トレメニュー名
    dynamic var trainingMenuName: String = ""
    // 筋トレ部位
    dynamic var trainingPart: String = ""
    // 作成日時
    dynamic var createdDate: Date = Date()
    // 更新日時
    dynamic var uodatedDate: Date = Date()
    
    // 筋トレメニューidをプライマリーキーに設定
    override class func primaryKey() -> String? {
        return "trainingMenuId"
    }
}
