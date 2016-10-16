//
//  classes.swift
//  cronut
//
//  Created by Jinxin Liu on 10/13/16.
//  Copyright © 2016 Jinxin Liu. All rights reserved.
//

import Foundation

class tag {
    var name: String
    var color: String
    var category: Character
    var id: Int
}

class recipe {
    var name: String
    var pic: String
    var tags: [Int]
}

class user {
    var name: String
    var longitude: Float
    var latitude: Float
}

class ingredient_list {
    var name: String
    var type: Bool
}

class ingredient {
    var name: String
}

class connector {
    var amount: Float
    var unit: Float
}

class scanner {}
