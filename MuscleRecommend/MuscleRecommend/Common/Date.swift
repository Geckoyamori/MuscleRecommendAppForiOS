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
    
    // Date型(2021-05-08T21:27:06.640Z)をString型(2021/05/08)に変換
    func toStringType(date: Date) -> String {
        let dateFormatter = DateFormatter()
        // timeZoneがJSTだと、型の変換で自動的に+-9時間されてしまうため、timeZoneをUTCに設定
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
}
