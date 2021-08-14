//
//  TrainingMenuModel.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/09.
//

import UIKit
import RealmSwift

// 筋トレメニューモデル
class TrainingMenuModel {
    
    // Realm
    let realm = try! Realm()
    
    // 一覧取得
    func selectTrainingMenuList() -> Results<TrainingMenuData>? {
        return realm.objects(TrainingMenuData.self)
    }
    
    // 筋トレメニューを追加
    func insertTrainingMenuData(trainingMenuName: String) {
        // 追加する筋トレメニューの設定
        let trainingMenuData = TrainingMenuData()
        trainingMenuData.trainingMenuName = trainingMenuName
        try! realm.write {
            realm.add(TrainingMenuData(value: trainingMenuData))
        }
    }
    
    // 選択した筋トレメニューを削除
    func deleteTrainingMenuData(trainingMenuList: Results<TrainingMenuData>, index: Int) {
        try! realm.write {
            realm.delete(trainingMenuList[index])
        }
    }
}
