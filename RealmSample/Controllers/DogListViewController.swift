//
//  DogListViewController.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import UIKit

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
    }
}

private extension DogListViewController {
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
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
