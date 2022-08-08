//
//  DogListViewController.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import UIKit
import RealmSwift

class DogListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var person: Person?
    
    init() {
        super.init(nibName: String(describing: DogListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNavigationBarItem()
    }
}

private extension DogListViewController {
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = person?.name
    }
    
    func setNavigationBarItem() {
        let addBarButtonItem = UIBarButtonItem(title: "＋追加", style: .done, target: self, action: #selector(tapAddButton))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func add(dog name: String) {
        let realm = try? Realm()
        try? realm?.write {
            let newDog = Dog()
            newDog.name = name
            person?.dogs.append(newDog)
        }
    }
    
    func dataReload() {
        let realm = try? Realm()
        guard let id = person?.id,
              let result = realm?.objects(Person.self).filter("id == %@", id).first else { return }
        person = result
        tableView.reloadData()
    }
}

@objc extension DogListViewController {
    func tapAddButton() {
        let alert = UIAlertController(title:"犬の名前を入力してください",
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
            self.add(dog: text)
            self.dataReload()
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // UIAlertControllerに表示するUITextField
        alert.addTextField(configurationHandler: {(text: UITextField!) -> Void in
        })
        present(alert, animated: true)
    }
}

extension DogListViewController: UITableViewDelegate {}

extension DogListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 対象の飼い主(Person)の保有する犬(Person.dogs)の数をCellの数として返す
        return person?.dogs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // 対象となる犬(Dogクラス)を取得
        let dog = person?.dogs[indexPath.row]
        // Cellのタイトルラベルに犬の名前を代入
        cell.textLabel?.text = dog?.name
        return cell
    }
}
