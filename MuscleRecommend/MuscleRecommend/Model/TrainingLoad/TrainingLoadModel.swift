//
//  TrainingLoadModel.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/09.
//

import UIKit
import RealmSwift

// 筋トレ負荷量モデル
class TrainingLoadModel {
    
    // Realm
    let realm = try! Realm()
    
    // 筋トレ記録idとセット種類に紐づく筋トレ負荷量リストを取得
    func selectTrainingLoadList(trainingRecordId: String, setType: String) -> Results<TrainingLoadData>? {
        return realm.objects(TrainingLoadData.self).filter("trainingRecordId == '\(trainingRecordId)'").filter("trainingSetType == '\(setType)'").sorted(byKeyPath: "noOfSet", ascending: true)
    }
    
    // 筋トレ記録idに紐づく筋トレ記録の取得
    func selectTargetTrainingRecord(trainingRecordId: String) -> Results<TrainingRecordData>? {
        return realm.objects(TrainingRecordData.self).filter("trainingRecordId == '\(String(describing: trainingRecordId))'")
    }
        
    // 入力した記録データを筋トレ記録に追加（新規登録）
    func insertTrainingRecordData(trainingRecordData: TrainingRecordData) {
        try! realm.write {
            realm.add(TrainingRecordData(value: trainingRecordData))
        }
    }
    
    // 入力した筋トレ負荷量データを筋トレ負荷量テーブルに追加（新規登録）
    // 総負荷量を算出
    func insertTrainingLoadData(trainingRecordId: String, trainingLoadRecordDic: [String: TrainingLoadRecord]) -> Double {
        var totalTrainingLoad: Double = 0
        for trainingLoadRecord in trainingLoadRecordDic {
            // 追加する筋トレ負荷量の設定
            let trainingLoadData = TrainingLoadData()
            trainingLoadData.trainingRecordId = trainingRecordId
            trainingLoadData.trainingSetType = trainingLoadRecord.value.trainingSetType
            trainingLoadData.noOfSet = trainingLoadRecord.value.noOfSet
            trainingLoadData.weight = trainingLoadRecord.value.weight
            trainingLoadData.rep = trainingLoadRecord.value.rep
            try! realm.write {
                realm.add(TrainingLoadData(value: trainingLoadData))
            }
            // 総負荷量の算出
            totalTrainingLoad += trainingLoadRecord.value.weight * Double(trainingLoadRecord.value.rep)
        }
        return totalTrainingLoad
    }
    
    // 筋トレ記録をupdate（編集登録）
    func updateTrainingRecordData(trainingRecordId: String, totalWarmUpTrainingLoad: Double, totalMainTrainingLoad: Double) {
        // 更新する筋トレ記録の設定
        let trainingRecordData = realm.objects(TrainingRecordData.self).filter("trainingRecordId == '\(trainingRecordId)'")
        try! realm.write {
            trainingRecordData[0].totalWarmUpTrainingLoad = totalWarmUpTrainingLoad
            trainingRecordData[0].totalMainTrainingLoad = totalMainTrainingLoad
            trainingRecordData[0].updatedDate = Date().toJapaneseDeviceDate()
        }
    }
    
    // 入力した筋トレ負荷量データをupdate（編集登録）
    // 総負荷量を算出
    func updateTrainingLoadData(trainingLoadRecordDic: [String: TrainingLoadRecord]) -> Double {
        var totalTrainingLoad: Double = 0
        for trainingLoadRecord in trainingLoadRecordDic {
            // 追加する筋トレ負荷量の設定
            let trainingLoadData = realm.objects(TrainingLoadData.self).filter("trainingLoadId == '\(trainingLoadRecord.value.trainingLoadId)'")
            try! realm.write {
                trainingLoadData[0].trainingSetType = trainingLoadRecord.value.trainingSetType
                trainingLoadData[0].noOfSet = trainingLoadRecord.value.noOfSet
                trainingLoadData[0].weight = trainingLoadRecord.value.weight
                trainingLoadData[0].rep = trainingLoadRecord.value.rep
                trainingLoadData[0].updatedDate = Date().toJapaneseDeviceDate()
            }
            // 総負荷量の算出
            totalTrainingLoad += trainingLoadRecord.value.weight * Double(trainingLoadRecord.value.rep)
        }
        return totalTrainingLoad
    }
    
//    // 筋トレメニューのDBから削除
//    func deleteTrainingMenuData(index: Int) {
//        try! realm.write {
//            realm.delete(trainingMenuList[index])
//        }
//    }
}

