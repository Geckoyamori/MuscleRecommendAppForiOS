//
//  TrainingRecordModel.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/09.
//

import UIKit
import RealmSwift

// 筋トレ記録モデル
class TrainingRecordModel: Object {
    
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

extension TrainingRecordModel {
    
    // Realm
    private static let realm = try! Realm()
    
    // 筋トレメニューidに紐づく筋トレ記録のリストを取得
    func selectTrainingRecordList(trainingMenuId: String) -> Results<TrainingRecordModel>? {
        return TrainingRecordModel.realm.objects(TrainingRecordModel.self).filter("trainingMenuId == '\(String(describing: trainingMenuId))'").sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    // 筋トレメニューidと筋トレ強度に紐づく筋トレ記録のリストを取得
    func selectTrainingRecordListByStrength(trainingMenuId: String, strength: String) -> Results<TrainingRecordModel>? {
        return TrainingRecordModel.realm.objects(TrainingRecordModel.self).filter("trainingMenuId == '\(String(describing: trainingMenuId))'").filter("trainingStrength == '\(strength)'").sorted(byKeyPath: "createdDate", ascending: false)
    }
    
//    // 筋トレメニューのDBに追加
//    func insertTrainingMenuModel(trainingMenuName: String) {
//        // 追加する筋トレメニューの設定
//        let trainingMenuModel = TrainingMenuModel()
//        trainingMenuModel.trainingMenuName = trainingMenuName
//        try! realm.write {
//            realm.add(TrainingMenuModel(value: trainingMenuModel))
//        }
//    }
//
    // 選択した筋トレ記録を削除
    func deleteTrainingRecordData(trainingRecordList: Results<TrainingRecordModel>, index: Int) {
        try! TrainingRecordModel.realm.write {
            TrainingRecordModel.realm.delete(trainingRecordList[index])
        }
    }
    
}
