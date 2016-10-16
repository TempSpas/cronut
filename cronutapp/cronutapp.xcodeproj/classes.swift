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
    static var numTags = 0


    // Function to initialize a tag class instance
    init(label: String, col: String, cat: Character) {
        name = label
        color = col
        category = cat 
        id = Tag.numTags+1
        Tag.numTags += 1
    }
}

class Recipe {
    var name: String
    var pic: String
    var tags: [UnsafePointer<Tag>]

    // Function to initialize a recipe class instance
    init(dish: String, picture: String, allTags: [UnsafePointer<Tag>]) {
        name = dish 
        pic = picture 
        tags = allTags 
    }
}

class User {
    var name: String
    var longitude: Float?
    var latitude: Float?
    var recipes: [UnsafePointer<Recipe>]?

    // Function to initialize the user class instance 
    init(user: String) {
        name = user
        longitude = nil 
        latitude = nil
        recipes = nil
    }
}

// A user has two lists: a grocery list and an inventory list
class Ingredient_list {
    var name: [String]?
    var type: Bool

    // Function to initialize a list. type == 0: grocery list. type == 1: inventory
    init(boolean: Bool) {
        type = boolean
        name = []
    }
}

class Ingredient {
    var name: String

    // Function to initialize an ingredient 
    init(ingredient: String) {
        name = ingredient 
    }
}

class Connector {
    var amount: Float
    var unit: Float

    init(quantity: Float, ut: Float) {
        amount = quantity 
        unit = ut 
    }
}

class Scanner {
   
    init() {

    }
}
