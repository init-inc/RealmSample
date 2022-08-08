//
//  Dog.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import Foundation
import RealmSwift

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
