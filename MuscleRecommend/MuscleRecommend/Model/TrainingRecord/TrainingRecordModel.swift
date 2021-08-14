//
//  TrainingRecordModel.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/09.
//

import UIKit
import RealmSwift

// 筋トレ記録モデル
class TrainingRecordModel {
    
    // Realm
    let realm = try! Realm()
    
    // 筋トレメニューidに紐づく筋トレ記録のリストを取得
    func selectTrainingRecordList(trainingMenuId: String) -> Results<TrainingRecordData>? {
        return realm.objects(TrainingRecordData.self).filter("trainingMenuId == '\(String(describing: trainingMenuId))'").sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    // 筋トレメニューidと筋トレ強度に紐づく筋トレ記録のリストを取得
    func selectTrainingRecordListByStrength(trainingMenuId: String, strength: String) -> Results<TrainingRecordData>? {
        return realm.objects(TrainingRecordData.self).filter("trainingMenuId == '\(String(describing: trainingMenuId))'").filter("trainingStrength == '\(strength)'").sorted(byKeyPath: "createdDate", ascending: false)
    }
    
//    // 筋トレメニューのDBに追加
//    func insertTrainingMenuData(trainingMenuName: String) {
//        // 追加する筋トレメニューの設定
//        let trainingMenuData = TrainingMenuData()
//        trainingMenuData.trainingMenuName = trainingMenuName
//        try! realm.write {
//            realm.add(TrainingMenuData(value: trainingMenuData))
//        }
//    }
//
    // 選択した筋トレ記録を削除
    func deleteTrainingRecordData(trainingRecordList: Results<TrainingRecordData>, index: Int) {
        try! realm.write {
            realm.delete(trainingRecordList[index])
        }
    }
}

