//
//  classes.swift
//  cronut
//
//  Created by Jinxin Liu on 10/13/16.
//  Copyright © 2016 Jinxin Liu. All rights reserved.
//

import Foundation

class Tag {
    var name: String
    var color: String
    var category: Character
    var id: Int
}

class Recipe {
    var name: String
    var pic: String
    var tags: [UnsafePointer<Tag>]
}

class User {
    var name: String
    var longitude: Float
    var latitude: Float
    var recipes: [UnsafePointer<Recipe>]
}

class Ingredient_list {
    var name: String
    var type: Bool
}

class Ingredient {
    var name: String
}

class Connector {
    var amount: Float
    var unit: Float
}

class Scanner {}
