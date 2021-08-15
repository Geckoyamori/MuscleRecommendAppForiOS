//
//  TrainingMenuModel.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/09.
//

import UIKit
import RealmSwift

// 筋トレメニューモデル
class TrainingMenuModel: Object {
    
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

extension TrainingMenuModel {
    
    // Realm
    private static let realm = try! Realm()
    
    // 一覧取得
    func selectTrainingMenuList() -> Results<TrainingMenuModel>? {
        return TrainingMenuModel.realm.objects(TrainingMenuModel.self)
    }
    
    // 筋トレメニューを追加
    func insertTrainingMenuModel(trainingMenuName: String) {
        // 追加する筋トレメニューの設定
        let trainingMenuModel = TrainingMenuModel()
        trainingMenuModel.trainingMenuName = trainingMenuName
        try! TrainingMenuModel.realm.write {
            TrainingMenuModel.realm.add(TrainingMenuModel(value: trainingMenuModel))
        }
    }
    
    // 選択した筋トレメニューを削除
    func deleteTrainingMenuModel(trainingMenuList: Results<TrainingMenuModel>, index: Int) {
        try! TrainingMenuModel.realm.write {
            TrainingMenuModel.realm.delete(trainingMenuList[index])
        }
    }
}
