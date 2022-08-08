//
//  ViewController.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataList: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataReload()
    }
}

private extension ViewController {
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func dataReload() {
        let realm = try? Realm()
        guard let result = realm?.objects(Person.self) else { return }
        dataList = Array(result)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // まずはSectionの概念に相当するPersonを取得
        let person = dataList[section]
        // Person毎に保有するDogの数(=dogs)が異なるため
        // 取得したPersonに紐づくdogs.countをセルのカウントとして返す
        return person.dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
