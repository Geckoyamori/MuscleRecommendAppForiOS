//
//  TrainingRecordViewController.swift
//  MuscleRecommend
//
//  Created by 多喜和弘 on 2021/05/06.
//

import UIKit

// D-003
class TrainingRecordViewController: UIViewController {
    
    // D-002からのパラメータ
    // 筋トレメニュー
    var trainingMenuName: String?
    // 筋トレメニューid
    var trainingMenuId: String?
    // 筋トレ強度
    var trainingStrength: String?
    
    // 負荷量を記録するtableView
    @IBOutlet weak var recordTableView: UITableView!
    
    override func viewDidLoad() {
        // navigationbarの設定
        title = trainingMenuName
        
        // tableViewのdelegate
        recordTableView.delegate = self
        recordTableView.dataSource = self
    }
}

// tableViewのメソッド
extension TrainingRecordViewController: UITableViewDelegate, UITableViewDataSource {
    // tableViewの行数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    // tableViewのセルを設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel!.text = "sasas"
        return cell
    }
}
