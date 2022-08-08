//
//  DogListViewController.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import UIKit

class DogListViewController: UIViewController {
    init() {
        super.init(nibName: String(describing: DogListViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
