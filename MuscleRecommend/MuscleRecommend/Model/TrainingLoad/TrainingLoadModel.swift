//
//  TrainingLoadModel.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/09.
//

import UIKit
import RealmSwift

// 筋トレ負荷量モデル
class TrainingLoadModel: Object {
    
    // 筋トレ負荷量id
    @objc dynamic var trainingLoadId: String = NSUUID().uuidString
    // 筋トレ記録id
    @objc dynamic var trainingRecordId: String = NSUUID().uuidString
    // 筋トレセット種類
    @objc dynamic var trainingSetType: String = ""
    // セット
    @objc dynamic var noOfSet: Int = 0
    // 重量
    @objc dynamic var weight: Double = 0
    // 回数
    @objc dynamic var rep: Int = 0
    // 作成日時
    @objc dynamic var createdDate: Date = Date().toJapaneseDeviceDate()
    // 更新日時
    @objc dynamic var updatedDate: Date = Date().toJapaneseDeviceDate()
    
    // 筋トレ負荷量idをプライマリーキーに設定
    override class func primaryKey() -> String? {
        return "trainingLoadId"
    }

}

extension TrainingLoadModel {
    
    // Realm
    private static let realm = try! Realm()
    
    // 筋トレ記録idとセット種類に紐づく筋トレ負荷量リストを取得
    func selectTrainingLoadList(trainingRecordId: String, setType: String) -> Results<TrainingLoadModel>? {
        return TrainingLoadModel.realm.objects(TrainingLoadModel.self).filter("trainingRecordId == '\(trainingRecordId)'").filter("trainingSetType == '\(setType)'").sorted(byKeyPath: "noOfSet", ascending: true)
    }
    
    // 筋トレ記録idに紐づく筋トレ記録の取得
    func selectTargetTrainingRecord(trainingRecordId: String) -> Results<TrainingRecordModel>? {
        return TrainingLoadModel.realm.objects(TrainingRecordModel.self).filter("trainingRecordId == '\(String(describing: trainingRecordId))'")
    }
        
    // 入力した記録データを筋トレ記録に追加（新規登録）
    func insertTrainingRecordData(trainingRecordModel: TrainingRecordModel) {
        try! TrainingLoadModel.realm.write {
            TrainingLoadModel.realm.add(TrainingRecordModel(value: trainingRecordModel))
        }
    }
    
    // 入力した筋トレ負荷量データを筋トレ負荷量テーブルに追加（新規登録）
    // 総負荷量を算出
    func insertTrainingLoadModel(trainingRecordId: String, trainingLoadRecordDic: [String: TrainingLoadRecord]) -> Double {
        var totalTrainingLoad: Double = 0
        for trainingLoadRecord in trainingLoadRecordDic {
            // 追加する筋トレ負荷量の設定
            let trainingLoadModel = TrainingLoadModel()
            trainingLoadModel.trainingRecordId = trainingRecordId
            trainingLoadModel.trainingSetType = trainingLoadRecord.value.trainingSetType
            trainingLoadModel.noOfSet = trainingLoadRecord.value.noOfSet
            trainingLoadModel.weight = trainingLoadRecord.value.weight
            trainingLoadModel.rep = trainingLoadRecord.value.rep
            try! TrainingLoadModel.realm.write {
                TrainingLoadModel.realm.add(TrainingLoadModel(value: trainingLoadModel))
            }
            // 総負荷量の算出
            totalTrainingLoad += trainingLoadRecord.value.weight * Double(trainingLoadRecord.value.rep)
        }
        return totalTrainingLoad
    }
    
    // 筋トレ記録をupdate（編集登録）
    func updateTrainingRecordData(trainingRecordId: String, totalWarmUpTrainingLoad: Double, totalMainTrainingLoad: Double) {
        // 更新する筋トレ記録の設定
        let trainingRecordModel = TrainingLoadModel.realm.objects(TrainingRecordModel.self).filter("trainingRecordId == '\(trainingRecordId)'")
        try! TrainingLoadModel.realm.write {
            trainingRecordModel[0].totalWarmUpTrainingLoad = totalWarmUpTrainingLoad
            trainingRecordModel[0].totalMainTrainingLoad = totalMainTrainingLoad
            trainingRecordModel[0].updatedDate = Date().toJapaneseDeviceDate()
        }
    }
    
    // 入力した筋トレ負荷量データをupdate（編集登録）
    // 総負荷量を算出
    func updateTrainingLoadModel(trainingLoadRecordDic: [String: TrainingLoadRecord]) -> Double {
        var totalTrainingLoad: Double = 0
        for trainingLoadRecord in trainingLoadRecordDic {
            // 追加する筋トレ負荷量の設定
            let trainingLoadModel = TrainingLoadModel.realm.objects(TrainingLoadModel.self).filter("trainingLoadId == '\(trainingLoadRecord.value.trainingLoadId)'")
            try! TrainingLoadModel.realm.write {
                trainingLoadModel[0].trainingSetType = trainingLoadRecord.value.trainingSetType
                trainingLoadModel[0].noOfSet = trainingLoadRecord.value.noOfSet
                trainingLoadModel[0].weight = trainingLoadRecord.value.weight
                trainingLoadModel[0].rep = trainingLoadRecord.value.rep
                trainingLoadModel[0].updatedDate = Date().toJapaneseDeviceDate()
            }
            // 総負荷量の算出
            totalTrainingLoad += trainingLoadRecord.value.weight * Double(trainingLoadRecord.value.rep)
        }
        return totalTrainingLoad
    }
    
//    // 筋トレメニューのDBから削除
//    func deleteTrainingMenuModel(index: Int) {
//        try! realm.write {
//            realm.delete(trainingMenuList[index])
//        }
//    }
    
}
