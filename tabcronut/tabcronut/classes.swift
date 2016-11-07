//
//  classes.swift
//  cronut
//
//  Created by Jinxin Liu on 10/13/16.
//  Copyright © 2016 Jinxin Liu. All rights reserved.
//

import UIKit
import Foundation

// Used to create random numbers
extension CGFloat 
{
    static func random() -> CGFloat 
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// Used to create a random color with the above extension for CGFloat
extension UIColor 
{
    static func randomColor() -> UIColor 
    {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

class Recipe 
{
	var name: String
	var image: UIImageView?=nil
	// Array of directions in order of use
	var directions: [String]
	// Maps an Ingredient to a pair (Amount, Measurement Type)
	var ingredients: [String: (Float, String)]  
	// Map of tags, associates them with a text color and a category indicator
	var tags: [String: (UIColor, Character)]
	var ID: Int
	static var NumRecipes: Int = 0

	// Creates a new recipe object
	// Params:   dish is the name of the recipe 
	//           picture is the file path of the picture to be used for the recipe  (optional)
	//           allTags is the list of tags for the recipe (optional)
	// Modifies: name, image, tags
	// Effects:  name, image, and tags are all assigned their respective parameters
	init(title: String, picture: String? = nil)
	{
		name = title
		ingredients = [:]
		directions = []
		if picture != nil 
		{
			image = UIImageView(image: UIImage(named: picture!)!)
		}
		ID = Recipe.NumRecipes + 1
		Recipe.NumRecipes += 1
        tags = [:]
	}

	// Creates a new recipe object from an old one
	// Params:   oldRecipe is an existing recipe object to be duplicated
	// Modifies: name, image, tags, ingredients, directions 
	// Effects:  name, image, tags, ingredients, and directions are all assigned 
	//           their respective values in oldRecipe
	init(oldRecipe: Recipe)
	{
		name = oldRecipe.name 
		image = oldRecipe.image
		ingredients = oldRecipe.ingredients 
		directions = oldRecipe.directions
		ID = Recipe.NumRecipes + 1
		Recipe.NumRecipes += 1
        tags = oldRecipe.tags
    }

	// Adds a tag to the tag map for this recipe 
	// Params:   newTag is a string that is the tag name 
	//			 newColor is the color that the tag should be displayed as on the recipe page (optional)
	//				if a color is not provided, a random one is chosen
	//			 newCat is a character indicating the category that the tag falls under (optional)
	// Modifies: tags 
	// Effects:  a new tag is added to the tags map 
	// Returns:  false if a tag with the same name already exists for this recipe, else true
	func addTag(newTag: String, newColor: UIColor? = nil, newCat: Character? = nil) -> Bool
	{
		if tags[newTag] == nil
		{
			if newColor == nil 
			{
				var newC = UIColor()
                newC = .randomColor()
                tags[newTag] = (newC, newCat!)
                return true
			}
            
            else
            {
                tags[newTag] = (newColor!, newCat!)
                return true
            }
		}

		return false
	}

	// Removes a tag from the tag map for this recipe 
	// Params:   oldTag is the name of the tag to be removed from this recipe
	// Modifies: tags 
	// Effects:  oldTag is removed from the tags map if it is in it
	// Returns:  false if a tag with the same name already exists for this recipe, else true
	func removeTag(oldTag: String) -> Bool 
	{
		if tags[oldTag] == nil {return false}
		tags[oldTag] = nil 
		return true
	}

	// Changes the name of a recipe
	// Params:   newName is a string the change the recipe name to 
	// Modifies: name
	// Effects:  name is changed to newName 
	// Returns:  true if successful, else false
	func rename(newName: String) -> Bool
	{
		if newName == nil || newName == "" {return false}
		name = newName
		return true
	}

	// Changes the picture associated with a recipe
	// Params:   picFileName is the file path to the new picture to be used
	// Modifies: image
	// Effects:  image is modified to take on the pic associated with picFileName
	func changePic(picFileName: String)     
	{
		image = UIImageView(image: UIImage(named:picFileName)!)     //****check to make sure file exists****
	}

	// Adds an ingredient to this recipe's ingredients list
	// Params:   ingredient is the name of the ingredient 
	//           amount is the numerical amount of the ingredient needed (optional)
	//           measurement is the unit of measurement (i.e. cup, ounce, liter) (optional)
	// Modifies: ingredients
	// Effects:  ingredients is appended with the new ingredient and its information
	// Returns:  true if the information was added, else false 
	func addIngredient(ingredient: String, amount: Float? = nil, measurement: String? = nil) -> Bool
	{
		if ingredient == nil || ingredient == "" {return false}
		if ingredients[ingredient] != nil
		{
			return false
		}
		ingredients[ingredient] = (amount, measurement)
		return true
	}

	// Adds an ingredient to this recipe's ingredients list
	// Params:   ingredient is the name of the ingredient 
	// Modifies: ingredients
	// Effects:  ingredients has key ingredient and its info removed
	func removeIngredient(ingredient: String)
	{
		ingredients[ingredient] = nil
	}

	// Modify an ingredient's information
	// Params:   ingredient is the name of the ingredient 
	//           amount is the numerical amount of the ingredient needed (optional)
	//           measurement is the unit of measurement (i.e. cup, ounce, liter) (optional)
	// Modifies: ingredients
	// Effects:  ingredients[ingredient] is modified with its new data
	// Returns:  true if the information was changed, else false 
	func modIngredient(ingredient: String, amount: Float? = nil, measurement: String? = nil) -> Bool
	{
		var amt: Float
		var mst: String
		if ingredients[ingredient] != nil
		{
			if amount == nil {amt = (ingredients[ingredient]?.0)!}
			else {
				amt = amount!
			}
			if measurement == nil {mst = (ingredients[ingredient]?.1)!}
			else    {
				mst = measurement!
			}
			ingredients[ingredient] = (amt, mst)
			return true
		}
		return false
	}

	// Adds a direction to this ingredient object
	// Params:   direction is a string to be added to the directions array 
	//           index is the index at which the direction should be added (optional)
	// Modifies: directions
	// Effects:  directions has the direction appended to it at the end or at index if specified
	// Returns:  true if the information was added, else false 
	func addDirection(direction: String, index1: Int? = nil) -> Bool
	{
		
		if directions.contains(direction)
		{
			// The direction is already in the directions, don't do anything
			return false
		}

		if index1 == nil || index1 < 0
		{
			directions.append(direction)
			return true
		}

		directions.insert(direction, at: index1!)
		return true
	}

	// Removes a direction from this ingredient object
	// Params:   direction is a string to be removed from the directions array 
	// Modifies: directions
	// Effects:  directions has the direction removed from it
	// Returns:  true if the information was removed, else false 
	func removeDirection(direction: String) -> Bool
	{
		if directions.contains(direction)
		{
			let index = directions.index(of: direction)
			directions.remove(at: index)
			return true
		}

		return false
	}

	// Changes a direction in this ingredient object
	// Params:   direction is a string to be changed in the directions array 
	//           newDirection is the direction to take its place
	// Modifies: directions
	// Effects:  directions has the element direction changed to newDirection
	// Returns:  true if the information was added, else false 
	func changeDirection(direction: String, newDirection: String) -> Bool
	{
		if newDirection == nil || newDirection == "" {return false}
		if directions.contains(direction)
		{
			let index = directions.index(of: direction)
			directions[index] = newDirection
			return true
		}

		return false
	}
}

extension Recipe: Equatable {}
	func ==(lhs: Recipe, rhs: Recipe) -> Bool   {
		return lhs.ID == rhs.ID
	}

extension Recipe: Hashable {
	var hashValue:Int   {
		return ID
	}
}

class User: NSObject, NSCoding
{
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
    }

	// MARK: Properties
	var name: String
	var longitude: Float?
	var latitude: Float?
	var recipes: [UnsafePointer<Recipe>]
	var groceries: [String: (Float, String)]
	var inventory: [String: (Float, String)]

	// MARK: Archiving Paths
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in:
		.userDomainMask).first!

	static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")

	// MARK: Types
	struct PropertyKey
	{
		static let nameKey = "name"
		static let recipesKey = "recipes"
	}

	// Initializes a new user object
	// Params:   
	// Modifies: 
	// Effects:  
    init(user: String)
	{
		name = user
		longitude = nil 
		latitude = nil
		recipes = []
        groceries = [:]
        inventory = [:]

		super.init()
	}

	// Attempts to add a grocery item to the grocery map
	// Params:   ingredient is the name of the ingredient as a string 
	//			 amount is a float indicating the numerical amount of the ingredient needed 
	//			 unit is the measurement type of the amount, such as cup/kilogram/litre 
	// Modifies: groceries
	// Effects:  a new key-value pair is added to the grocery map
	// Returns:  false if the item was already in the map or one of the arguments is invalid, otherwise true
	func addGrocery(ingredient: String, amount: Float? = nil, unit: String? = nil) -> Bool
	{
		if ingredient == nil || ingredient == "" {return false}
		if groceries[ingredient] != nil
		{
			/* 

			Should we then skip adding? Prompt the user to choose a new amount/measurement and 
			then call removeGrocery followed by addGrocery again?

			*/
			return false
		}

		else
		{
			groceries[ingredient] = (amount, unit)
			return true
		}
	}

	// Attempts to remove a grocery item from the grocery map
	// Params:   ingredient is the name of the ingredient to be removed from the map
	// Modifies: groceries
	// Effects:  the key 'ingredient' is removed from the groceries map if it exists
	// Returns:  true if the item was removed, otherwise false
	func removeGrocery(ingredient: String) -> Bool
	{
		if ingredient == nil || ingredient == "" {return false}
		if groceries[ingredient] == nil {return false}
		else 
		{
			groceries[ingredient] = nil 
			return true
		}
	}

	// Attempts to add an ingredient to the inventory map
	// Params:   ingredient is the name of the ingredient as a string 
	//			 amount is a float indicating the numerical amount of the ingredient needed 
	//			 unit is the measurement type of the amount, such as cup/kilogram/litre 
	// Modifies: inventory
	// Effects:  a new key-value pair is added to the inventory map
	// Returns:  false if the item was already in the map, otherwise true
	func addInventory(ingredient: String, amount: Float? = nil, unit: String? = nil) -> Bool
	{
		if ingredient == nil || ingredient == "" {return false}
		if inventory[ingredient] != nil
		{
			/* 

			Should we then skip adding? Prompt the user to choose a new amount/measurement and 
			then call removeInventory followed by addInventory again?

			*/
			return false
		}

		else
		{
			inventory[ingredient] = (amount, unit)
			return true
		}
	}

	// Attempts to remove an ingredient from the inventory map
	// Params:   ingredient is the name of the ingredient to be removed from the map
	// Modifies: inventory
	// Effects:  the key 'ingredient' is removed from the inventory map if it exists
	// Returns:  true if the item was removed, otherwise false
	func removeInventory(ingredient: String) -> Bool
	{
		if ingredient == nil || ingredient == "" {return false}
		if inventory[ingredient] == nil {return false}
		inventory[ingredient] = nil 
		return true
	}

	func encodeWithCoder(aCoder: NSCoder)
	{
		aCoder.encode(name, forKey: PropertyKey.nameKey)
//		aCoder.encode(recipes, forKey: PropertyKey.recipesKey)
	}

	required convenience init?(coder aDecoder: NSCoder)
	{
		let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
//		let recipes = aDecoder.decodeObject(forKey: PropertyKey.recipesKey) as! [Recipe]

		// Must call designated rnitializer
		self.init(user: name)
	}

}
