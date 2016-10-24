//
//  classes.swift
//  cronut
//
//  Created by Jinxin Liu on 10/13/16.
//  Copyright © 2016 Jinxin Liu. All rights reserved.
//

import UIKit
import Foundation

class Tag 
{
    var name: String
    var color: UIColor
    var category: Character
    var id: Int
    // An array of recipe pointers who all use this tag
    var recipes: [UnsafePointer<Recipe>]
    static var numTags = 0

    // Creates a new tag object
    // Params:   label is the String to be used as the tag name
    //           col is the color that the tag background should be 
    //           cat is the category that the tag falls under
    // Modifies: name, color, category, id, numTags
    // Effects:  name, color, and category are all assigned their corresponding parameter 
    //           id is assigned (the number of tags that exists) + 1
    //           numTags is incremented by one 
    // Returns:  false if a tag with the name 'label' already exists
    //           true if a new object is created
    init(label: String, col: UIColor, cat: Character)
    {
        name = label
        color = col
        category = cat 
        id = Tag.numTags + 1
        Tag.numTags += 1
        recipes = []
    }

    // Changes the color of a tag
    // Params:   newColor is the new color for the tag background
    // Modifies: color
    // Effects:  color takes on the value of newColor
    func changeColor(newColor: UIColor)
    {
        color = newColor 
    }

    // Adds a recipe pointer to the recipe array
    // Params:   newRecipe is a pointer to an existing recipe to be added to the recipe array
    // Modifies: recipes
    // Effects:  recipes has the newRecipe pointer appended to the end
    // Returns:  true if the recipe was successfully added, else false
    func addRecipe(newRecipe: UnsafePointer<Recipe>) -> Bool
    {
        // Check if a pointer exists in the recipes array with the same memory address (I think)
        let ind = recipes.contains(newRecipe)
        if ind
        {
            // Recipe already exists, do nothing
            return false
        }
        recipes.append(newRecipe)
        return true
    }

    // Removes a recipe pointer from the array list
    // Params:   oldRecipe
    // Modifies: recipes
    // Effects:  The oldRecipe pointer is removed frmo the recipes array
    // Returns:  true if the pointer was successfully removed, else false
    func removeRecipe(oldRecipe: UnsafePointer<Recipe>) -> Bool
    {
        // Check if a pointer exists in the recipes array with the same memory address (I think)
        let ind = recipes.contains(oldRecipe)
        if ind
        {
            // Recipe no longer uses this tag, remove recipe from tag list
            recipes.remove(at: recipes.index(of: oldRecipe)!)
            return true
        }
        return false
    }
}

// The following is outside of the above class, allows class to be equatable, comparable, and hashable
    
    // Allows tags to be equatable
    extension Tag: Equatable {}
    
    func ==(lhs: Tag, rhs: Tag) -> Bool 
    {
        return lhs.name == rhs.name
    }
    
    // Allows tags to be hashable
    extension Tag: Hashable 
    {
        var hashValue: Int 
        {
            return name.hashValue
        }
    }

    // Allows tags to be sorted in alphabetical order, yes this is supposed to be empty
    extension Tag: Comparable {}

    func <=(lhs: Tag, rhs: Tag) -> Bool 
    {
        return lhs.name <= rhs.name
    }

    func >(lhs: Tag, rhs: Tag) -> Bool 
    {
        return lhs.name > rhs.name
    }
    
    func <(lhs: Tag, rhs: Tag) -> Bool 
    {
        return lhs.name < rhs.name
    }

    func >=(lhs: Tag, rhs: Tag) -> Bool 
    {
        return lhs.name >= rhs.name
    }

class Recipe 
{
    var name: String
    var image: UIImageView?=nil
    // Array of tags that the recipe uses
    //var tags: [UnsafePointer<Tag>]
    // Maps an Ingredient to a pair (Amount, Measurement Type)
    var ingredients: [String: (Float, String)]  
    // Array of directions in order of use
    var directions: [String]
    var ID: Int
    static var NumRecipes: Int = 0

    // Creates a new recipe object
    // Params:   dish is the name of the recipe 
    //           picture is the file path of the picture to be used for the recipe  (optional)
    //           allTags is the list of tags for the recipe (optional)
    // Modifies: name, image, tags
    // Effects:  name, image, and tags are all assigned their respective parameters
    init(title: String, picture: String? = nil, allTags: [UnsafePointer<Tag>]? = nil)
    {
        name = title
        ingredients = [:]
        directions = []
        //tags = []
        if picture != nil 
        {
            image = UIImageView(image: UIImage(named: picture!)!)
        }
        ID = Recipe.NumRecipes + 1
        Recipe.NumRecipes += 1
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
        //tags = oldRecipe.tags
        ingredients = oldRecipe.ingredients 
        directions = oldRecipe.directions
        ID = Recipe.NumRecipes + 1
        Recipe.NumRecipes += 1
    }

    // Changes the name of a recipe
    // Params:   newName is a string the change the recipe name to 
    // Modifies: name
    // Effects:  name is changed to newName 
    func rename(newName: String) 
    {
        name = newName
    }

    // Changes the picture associated with a recipe
    // Params:   picFileName is the file path to the new picture to be used
    // Modifies: image
    // Effects:  image is modified to take on the pic associated with picFileName
    func changePic(picFileName: String)     
    {
        image = UIImageView(image: UIImage(named:picFileName)!)     //****check to make sure file exists****
    }

    // Add a new tag to this recipe
    // Params:   newTag is a pointer to the new tag to be used by the recipe
    // Modifies: tags, newTag
    // Effects:  the newTag pointer is added to the tags array 
    //           the newTag object has a reference to this recipe object added to its memory
    // Returns:  true if the tag was added, else false
    /*func addTag(newTag: UnsafePointer<Tag>) -> Bool
    {
        let ind = tags.contains(newTag)
        if ind
        {
            // The tag is already in the tag list, do nothing
            return false
        }

        tags.append(newTag)
        return true
    }

    // Remove a tag from this recipe
    // Params:   oldTag
    // Modifies: tags, oldTag
    // Effects:  tags has oldTag removed from itself 
    //           oldTag has the reference to this recipe removed from its memory
    // Returns:  true if the tag was removed, else false (tag already not in recipe)
    func removeTag(oldTag: UnsafePointer<Tag>) -> Bool
    {
        let ind = tags.contains(oldTag)
        if ind
        {
            // The tag is in the tag list, remove it.
            tags.remove(at: tags.index(of: oldTag)!)
            // Tell the tag that this recipe doesn't use it anymore (I think)
            return true 
        }
        return false
    }*/

    // Adds an ingredient to this recipe's ingredients list
    // Params:   ingredient is the name of the ingredient 
    //           amount is the numerical amount of the ingredient needed 
    //           measurement is the unit of measurement (i.e. cup, ounce, liter)
    // Modifies: ingredients
    // Effects:  ingredients is appended with the new ingredient and its information
    // Returns:  true if the information was added, else false 
    func addIngredient(ingredient: String, amount: Float, measurement: String) -> Bool
    {
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

        if index1 == nil
        {
            directions.append(direction)
            return true
        }
        directions.insert(direction, at: index1!)
        return true
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

class User
{
    var name: String
    var longitude: Float?
    var latitude: Float?
    var recipes: [UnsafePointer<Recipe>]

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
    }
}

// A user has two lists: a grocery list and an inventory list
class Ingredient_list 
{
    var myDict: [String: (Float, String)]
    var type: Bool

    // Function to initialize a list. type == 0: grocery list. type == 1: inventory
    init(boolean: Bool) 
    {
        type = boolean
        myDict = [:]
    }

    // Add an ingredient to the list 
    func addItem(ingredient: String, amount: Float, unit: String) 
    {
        myDict[ingredient] = (amount, unit)
    }

    // Remove an ingredient from the list 
    func removeItem(ingredient: String)
    {
        myDict[ingredient] = nil
    }
}

//class Scanner 
//{
//    /* Code from the internet, URL: https://github.com/A9T9/code-snippets/blob/master/ocrapi.swift */
//
//    func callOCRSpace() {
//        // Create URL request
//        var url: NSURL = NSURL(string: "https://api.ocr.space/Parse/Image")
//        var request: NSMutableURLRequest = NSMutableURLRequest.requestWithURL(url)
//        request.HTTPMethod = "POST"
//        var boundary: String = "randomString"
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        var session: NSURLSession = NSURLSession.sharedSession()
//        
//        // Image file and parameters
//        var imageData: NSData = UIImageJPEGRepresentation(UIImage.imageNamed("yourImage"), 0.6)
//        var parametersDictionary: [NSObject : AnyObject] = NSDictionary(objectsAndKeys: "yourKey","apikey","True","isOverlayRequired","eng","language",nil)
//        
//        // Create multipart form body
//        var data: NSData = self.createBodyWithBoundary(boundary, parameters: parametersDictionary, imageData: imageData, filename: "yourImage.jpg")
//        request.HTTPBody = data
//        
//        // Start data session
//        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData, response: NSURLResponse, error: NSError) in 
//            var myError: NSError
//            var result: [NSObject : AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: kNilOptions, error: &myError)
//            // Handle result
//        })
//
//        task.resume()
//    }
//    
//    func createBodyWithBoundary(boundary: String, parameters parameters: [NSObject : AnyObject], imageData data: NSData, filename filename: String) -> NSData {
//        
//        var body: NSMutableData = NSMutableData.data()
//        
//        if data {
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData(data)
//            body.appendData(".dataUsingEncoding(NSUTF8StringEncoding))
//        }
//        
//        for key in parameters.allKeys {
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("\(parameters[key])\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        }
//        
//        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        return body
//    }
//
//    init() 
//    {
//
//    }
//}

/* CODE TO ADD CALENDAR EVENT, EXAMPLE FUNCTION CALL: addEventToCalendar(title: "Girlfriend birthday", description: "Remember or die!", startDate: NSDate(), endDate: NSDate())*/

/*      MUST IMPORT 'EventKit'
func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
    let eventStore = EKEventStore()

    eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
        if (granted) && (error == nil) {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.notes = description
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.saveEvent(event, span: .ThisEvent)
            } catch let e as NSError {
                completion?(success: false, error: e)
                return
            }
            completion?(success: true, error: nil)
        } else {
            completion?(success: false, error: error)
        }
    })
}
*/