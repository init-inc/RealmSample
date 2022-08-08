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
    
    func transitionToAddData() {
        let editViewController = DogListViewController()
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
}

extension PersonListViewController: UITableViewDelegate {
    
}

extension PersonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Section高さが足りずに文字れが見切れるので高さを調整
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Sectionタイトルを表示するため、表示対象Sectionに該当するPersonを取得
        let person = dataList[section]
        // 対象SectionのタイトルとしてPerson.nameを表示
        return person.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // まずはSectionの概念に相当するPersonを取得
        let person = dataList[section]
        // Person毎に保有するDogの数(=dogs)が異なるため
        // 取得したPersonに紐づくdogs.countをセルのカウントとして返す
        return person.dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // Section→Personの単位のため、indexPath.sectionを使って対象SectionのPersonを取得
        let person = dataList[indexPath.section]
        // Cell→Dogsの単位のため、indexPath.rowを使って対象CellのDogを取得
        let dog = person.dogs[indexPath.row]
        // Cellタイトルには犬の名前を表示
        cell.textLabel?.text = dog.name
        return cell
    }
}
