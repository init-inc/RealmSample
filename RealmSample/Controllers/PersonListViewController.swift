//
//  PersonListViewController.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import UIKit
import RealmSwift

class PersonListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBAction func addDataButton(_ sender: UIBarButtonItem) {
        showAddPersonAlert()
    }
    
    private var dataList: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        dataReload()
        // Realm内に保存されているデータを「Realm Studio」で確認するために
        // Realmデータが保存されているファイルのパスを出力
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}

private extension PersonListViewController {
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
    
    func showAddPersonAlert() {
        let alert = UIAlertController(title:"所有者名を入力してください",
                                      message: "",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action: UIAlertAction!) -> Void in
        })
        let defaultAction = UIAlertAction(title: "Add",
                                          style: .default,
                                          handler: { (action: UIAlertAction!) -> Void in
            // UIAlertController上のUITextFidleから文字列を取得
            guard let text = alert.textFields?.first?.text else { return }
            self.add(person: text)
            self.dataReload()
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // UIAlertControllerに表示するUITextField
        alert.addTextField(configurationHandler: {(text: UITextField!) -> Void in
        })
        present(alert, animated: true)
    }
    
    func transitionToAddData(with person: Person) {
        let editViewController = DogListViewController()
        // 画面遷移する際に選択された飼い主データ(Person)を渡す
        editViewController.person = person
        // UINavigationControllerを使って画面遷移
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func add(person name: String) {
        let realm = try? Realm()
        try? realm?.write {
            let newPerson = Person()
            newPerson.name = name
            realm?.add(newPerson)
        }
    }
    
    func delete(_ preson: Person) {
        let realm = try? Realm()
        try? realm?.write {
            // 飼い主データ(Person)を削除する際に飼い主に紐づく犬データ(Person.dogs)も削除
            preson.dogs.forEach { dog in
                realm?.delete(dog)
            }
            // 既存の飼い主データ(Person)を削除
            realm?.delete(preson)
        }
    }
}

extension PersonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたCellの飼い主データ(Person)を取得
        let person = dataList[indexPath.row]
        // 飼い主データ(Person)を使って画面遷移させる
        transitionToAddData(with: person)
        // タップされたCellの選択状態を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PersonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 飼い主(Person)の数だけCellを表示させる
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // indexPath.rowを使って対象CellのPersonを取得
        let person = dataList[indexPath.row]
        // Cellタイトルにはの飼い主の名前(Person.name)を表示
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // UITableViewを横スワイプで操作できるようにするフラグ
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // 削除対象の飼い主データ(Person)を取得
            let person = dataList[indexPath.row]
            delete(person)
            dataList.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            // 飼い主データ削除後にUITableViewを更新
            dataReload()
        default:
            // 削除以外の場合は操作しないのでbreak
            break
        }
    }
}
