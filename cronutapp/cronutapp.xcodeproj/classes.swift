//
//  classes.swift
//  cronut
//
//  Created by Jinxin Liu on 10/13/16.
//  Copyright © 2016 Jinxin Liu. All rights reserved.
//

import Foundation

class Tag 
{
    var name: String
    var color: String
    var category: Character
    var id: Int
    var recipes: [UnsafePointer<Recipe>]()
    static var numTags = 0

    // Function to initialize a tag class instance
    init(label: String, col: String, cat: Character) 
    {
        if let index = Tag.allTags.index(where: {$0 == label}) 
        {
            // A tag with this name already exists, do nothing
            return
        }

        name = label
        color = col
        category = cat 
        id = Tag.numTags + 1
        Tag.numTags += 1
    }

    // Change the display color of the tag 
    func changeColor(newColor: String)
    {
        color = newColor 
    }

    // Add a recipe to the tag list 
    func addRecipe(newRecipe: UnsafePointer<Recipe>)
    {
        // Check if a pointer exists in the recipes array with the same memory address (I think)
        if let index = this.recipes.index(where: {$0 === newRecipe}) 
        {
            // Recipe already exists, do nothing
            return
        }
        recipes.append(newRecipe)
    }

    // Remove a recipe from the tag list 
    func removeRecipe(oldRecipe: UnsafePointer<Recipe>)
    {
        // Check if a pointer exists in the recipes array with the same memory address (I think)
        if let index = this.recipes.index(where: {$0 === oldRecipe}) 
        {
            // Recipe no longer uses this tag, remove recipe from tag list
            recipes.remove(at: index)
        }
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
        var hashValue: Int {
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
    // (0,0) is the origin point for the start of the picture 
    // in the frame of size (width: 100, length: 200)
    var imageView: UIImageView
    var tags: [UnsafePointer<Tag>]
    var ingredients: [Ingredient: Connector]

    // Function to initialize a recipe class instance with a picture
    init(dish: String, picture: String, allTags: [UnsafePointer<Tag>]) 
    {
        name = dish 
        imageView = UIImageView(image: UIImage(named: picture)!)
        tags = allTags 
    }

    // Function to initialize a recipe class instance without a picture 
    init(dish: String, allTags: [UnsafePointer<Tag>]) 
    {
        name = dish
        tags = allTags
        imageView = UIImageView(frame:CGRectMake(0, 0, 100, 200)) 
    }

    // Change the name of a recipe 
    func rename(newName: String) 
    {
        name = newName
    }

    // Change the picture associated with the recipe
    func changePic(picFileName: String) 
    {
        imageView = UIImageView(image: UIImage(named:picFileName)!)
    }

    // Add a tag to the tag list 
    func addTag(newTag: UnsafePointer<Tag>) 
    {
        if let index = tags.index(where: {$0 === newTag}) 
        {
            // The tag is already in the tag list, do nothing
            return
        }

        tags.append(newTag)

        // Tell the tag that this recipe uses it (I think)
        newTag.memory.addRecipe(&this)
    }

    // Remove a tag from the tag list
    func removeTag(oldTag: UnsafePointer<Tag>) 
    {
        if let index = tags.index(where: {$0 === oldTag}) 
        {
            // The tag is in the tag list, remove it.
            tags.remove(at: index)
            // Tell the tag that this recipe doesn't use it anymore (I think)
            oldTag.memory.removeRecipe(&this)
        }
    }

    // Add ingredient to the recipe 
    func addIngredient(ingredient: String, amount: Float, measurement: String)
    {
        ingredients[ingredient] = Connector(amount, measurement)
    }

    // Remove ingredient from the recipe
    func removeIngredient(ingredient: String)
    {
        ingredients[ingredient] = nil
    }
}

class User 
{
    var name: String
    var longitude: Float?
    var latitude: Float?
    var recipes: [UnsafePointer<Recipe>]

    // Function to initialize the user class instance 
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
    var myDict: [String: Connector]
    var type: Bool

    // Function to initialize a list. type == 0: grocery list. type == 1: inventory
    init(boolean: Bool) 
    {
        type = boolean
    }

    // Add an ingredient to the list 
    func addItem(ingredient: String, amount: Float, unit: String) 
    {
        myDict[ingredient] = Connector(amount, unit)
    }

    // Remove an ingredient from the list 
    func removeItem(ingredient: String)
    {
        myDict[ingredient] = nil
    }
}

class Ingredient 
{
    var name: String

    // Function to initialize an ingredient 
    init(ingredient: String) 
    {
        name = ingredient 
    }
}

    // Allows ingredients to be hashable
    extension Ingredient: Hashable 
    {
        var hashValue: Int {
            return name.hashValue
        }
    }
    
    // Allows tags to be equatable
    extension Ingredient: Equatable {}
    
    func ==(lhs: Ingredient, rhs: Ingredient) -> Bool 
    {
        return lhs.name == rhs.name
    }

class Connector 
{
    var amount: Float
    var unit: String

    init(quantity: Float, ut: String) 
    {
        amount = quantity 
        unit = ut 
    }

    func changeAmt(quantity: Float)
    {
        amount = quantity
    }

    func changeUnit(newUnit: String)
    {
        unit = newUnit
    }
}

class Scanner 
{
    /* Code from the internet, URL: https://github.com/A9T9/code-snippets/blob/master/ocrapi.swift */

    func callOCRSpace() {
        // Create URL request
        var url: NSURL = NSURL(string: "https://api.ocr.space/Parse/Image")
        var request: NSMutableURLRequest = NSMutableURLRequest.requestWithURL(url)
        request.HTTPMethod = "POST"
        var boundary: String = "randomString"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var session: NSURLSession = NSURLSession.sharedSession()
        
        // Image file and parameters
        var imageData: NSData = UIImageJPEGRepresentation(UIImage.imageNamed("yourImage"), 0.6)
        var parametersDictionary: [NSObject : AnyObject] = NSDictionary(objectsAndKeys: "yourKey","apikey","True","isOverlayRequired","eng","language",nil)
        
        // Create multipart form body
        var data: NSData = self.createBodyWithBoundary(boundary, parameters: parametersDictionary, imageData: imageData, filename: "yourImage.jpg")
        request.HTTPBody = data
        
        // Start data session
        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData, response: NSURLResponse, error: NSError) in 
            var myError: NSError
            var result: [NSObject : AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: kNilOptions, error: &myError)
            // Handle result
        })

        task.resume()
    }
    
    func createBodyWithBoundary(boundary: String, parameters parameters: [NSObject : AnyObject], imageData data: NSData, filename filename: String) -> NSData {
        
        var body: NSMutableData = NSMutableData.data()
        
        if data {
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            body.appendData("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            body.appendData(data)
            body.appendData(".dataUsingEncoding(NSUTF8StringEncoding))
        }
        
        for key in parameters.allKeys {
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            body.appendData("\(parameters[key])\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        }
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        return body
    }

    init() 
    {

    }
}
