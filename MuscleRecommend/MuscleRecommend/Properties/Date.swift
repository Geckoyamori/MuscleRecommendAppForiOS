//
//  Date.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/06.
//

import UIKit

extension Date {
    // UTCをJSTに変換
    func toJapaneseDeviceDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        return calendar.date(byAdding: .hour, value: 9, to: date)!
    }
}
