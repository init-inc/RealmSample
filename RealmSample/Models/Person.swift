//
//  Person.swift
//  RealmSample
//
//  Created by Taku Yamada on 2022/08/08.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var name = ""
    let dogs = List<Dog>()
}
