//
//  AddRecipeViewController.swift
//  tabcronut
//
//  Created by Nico Verbeek on 10/23/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

// this file has code for the add recipe view controller
// this file allows a user to manually add a new recipe
// to the recipe book.

import UIKit
import MobileCoreServices

class AddRecipeViewController: //UITableViewController, UITextFieldDelegate {
UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
	var numRows = 1

	// MARK: Properties
	@IBOutlet weak var imageView: UIImageView!
	var newMedia: Bool?
	
	// initialize the variables that might be passed in the case of 
	// copying an existing recipe
	var pre_title: String?
	var pre_ingredients: [String: (Float, String)]?
	var pre_directions: [String]?
	var pre_tags: [String: (UIColor, String)]?
	var numIngrs: Int?
	var numTags: Int?

	// also keep track of variables that will be added
	var ingredients: [String: (Float, String)] = [:]
	var directions: [String] = []
	var test: [String] = []
	var tags: [String: (UIColor, String)] = [:]
	var temp_ingredient: String = ""
	var temp_amount: Float = 0.0
	var temp_unit: String = ""
	var num_newtags: Int = 0

	// MARK: properties
	// Connections to all of the UI components
	@IBOutlet weak var ingrName: UITextField!
	@IBOutlet weak var ingrAmt: UITextField!
	@IBOutlet weak var ingrUnit: UITextField! 
	@IBOutlet weak var recipeTitle: UITextField!
	@IBOutlet weak var saveRecipeButton: UIBarButtonItem! 
	@IBOutlet weak var ingredientTable: UITableView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var direction: UITextField!
	@IBOutlet weak var directionTable: UITableView!
	@IBOutlet weak var tagTable: UITableView!
	
	// Mark: Action for pressing "Add" button next to ingredients
	// function: adds the user-inputted values to the ingredients table
	@IBAction func addIngrs(_ sender: AnyObject) {
		self.ingredientTable.beginUpdates()
		
		// error checking for existing ingredient
		if ingredients[ingrName.text!] != nil  {
			ingrName.text=""
			ingrAmt.text=""
			ingrUnit.text=""
			let alertController = UIAlertController(title: "Error", message: "Please enter an ingredient that doesn't exist!", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
			self.present(alertController, animated: true, completion:nil)
			print("Ingredient already exists.")
			self.ingredientTable.endUpdates()
			return
		}
		
		// error checking for empty ingredient amount
		if ingrAmt.text != ""  {
			if Float(ingrAmt.text!) != nil {
				print("got float")
			}
			
			// we don't want an amount that is not a float
			else {
				let alertController = UIAlertController(title: "Error", message: "Please enter a FLOAT value for the amount", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
				self.present(alertController, animated: true, completion:nil)
				
				ingrAmt.text=""
				self.ingredientTable.endUpdates()
				return
			}
		}
		
		// error checking for empty amount and unit values
		// can't have a unit if there is no amount
		let emptyThings = (ingrAmt.text == nil || ingrAmt.text == "" || ingrUnit.text == nil || ingrUnit.text == "")
		let badThings = (ingrAmt.text == "" && ingrUnit.text != "")
		let someFilled = (ingrAmt.text != "" && ingrUnit.text == "")
		if emptyThings  {
			if badThings    {
				ingrName.text=""
				ingrAmt.text=""
				ingrUnit.text=""
				self.ingredientTable.endUpdates()
				return
			}
			if someFilled   {
				ingredients[ingrName.text!] = (Float(ingrAmt.text!)!, "")
			}
			else    {
				ingredients[ingrName.text!] = (Float(0), "")
			}
		}
		else    {
			ingredients[ingrName.text!] = (Float(ingrAmt.text!)!, ingrUnit.text!)
		}
		
		// add new rows to the table
		ingredientTable.insertRows(at: [
			NSIndexPath(row: ingredients.count-1, section: 0) as IndexPath
			], with: .bottom)
		temp_ingredient = ingrName.text!
		if emptyThings != true {
			temp_amount = Float(ingrAmt.text!)!
			temp_unit = ingrUnit.text!
		}
		if someFilled == true   {
			temp_amount = Float(ingrAmt.text!)!
		}
		
		// reset values of labels
		ingrName.text=""
		ingrAmt.text=""
		ingrUnit.text=""
		self.ingredientTable.endUpdates()
	}
	
	
	// add new direction to the direction table
	@IBAction func addDirection(_ sender: AnyObject) {
		self.directionTable.beginUpdates()
		let dirtext = String(directions.count+1) + ". " +  direction.text!
		directions.append(dirtext)
		directionTable.insertRows(at: [
			NSIndexPath(row: directions.count-1, section: 0) as IndexPath
			], with: .bottom)
		direction.text=""
		self.directionTable.endUpdates()
	}
	
	// add new tag to the tag table
	@IBAction func addTags(_ sender: Any) {
		print("HERE")
		self.tagTable.beginUpdates()
		let d = self.tagTable.numberOfRows(inSection: 0)
		num_newtags += 1
		tagTable.insertRows(at: [NSIndexPath(row: d, section: 0) as IndexPath], with: .bottom)
		self.tagTable.endUpdates()
	}

	var recipe: Recipe?
	
	// primary load view for the table
	// set delegates & data sources
	override func viewDidLoad() {
		super.viewDidLoad()
		//scrollView.contentSize.height = 1500
		self.hideKeyboardWhenTappedAround()
		
		if pre_ingredients != nil   {
			ingredients = pre_ingredients!
		}
		if pre_directions != nil    {
			directions = pre_directions!
		}
		
		recipeTitle.delegate = self
		
		if pre_title != nil {
			self.recipeTitle.text = pre_title!
		}
		
		self.ingredientTable.delegate = self
		self.ingredientTable.dataSource = self
		self.directionTable.delegate = self
		self.directionTable.dataSource = self
		self.tagTable.delegate = self
		self.tagTable.dataSource = self
		
	}
	
	// number of sections in the table
	 func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	// number of rows in each section for the table
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count: Int = 0
		if tableView == self.ingredientTable {
			return ingredients.count
		}
		if tableView == self.directionTable{
			return directions.count
		}
		if tableView == self.tagTable   {
			return tags.count + num_newtags
		}
		return count
	}
	
	// each cell for each row
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell1: UITableViewCell?
		
		// ingredient table view
		if tableView == self.ingredientTable    {
			let cell = ingredientTable.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
			
			print(indexPath)
			let row = indexPath.row
			let ingredientNames = [String](ingredients.keys)
			let ingredientValues = [(Float, String)](ingredients.values)
			
			print(ingredientNames[row])
			if numIngrs != nil && numIngrs == ingredients.count {
				cell.ingrLabel.text = String(ingredientNames[row])
				if String(ingredientValues[row].0) != "0.0" {
					cell.ingrAmount.text = String(ingredientValues[row].0)
				}
				cell.ingrUnit.text = ingredientValues[row].1
				return cell
			}
			
			
			cell.ingrLabel.text = temp_ingredient
			if String(temp_amount) != "0.0" {
				cell.ingrAmount.text = String(temp_amount)
			}
			else    {
				cell.ingrAmount.text = ""
			}
			cell.ingrUnit.text = temp_unit
			
			temp_ingredient = ""
			temp_amount = 0.0
			temp_unit = ""
			return cell
		}
		
		//direction table view
		if tableView == self.directionTable    {
			let cell = directionTable.dequeueReusableCell(withIdentifier: "DirCell", for: indexPath) as! DirectionTableViewCell
			let row = indexPath.row
			cell.directionName.text = directions[row]
			return cell
		}
		
		//tag table view
		if tableView == self.tagTable   {
			let cell = tagTable.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCellTableViewCell
			//var row = indexPath.row
			cell.tagName.text = ""
			cell.tagColor.text = ""
			cell.tagCategory.text = ""
			
			return cell
		}
		return cell1!
	}


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	// enable editing for all three tables
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == .delete) {
			if tableView == self.ingredientTable    {
				let currentCell = tableView.cellForRow(at: indexPath)! as! IngredientTableViewCell
				ingredients.removeValue(forKey: currentCell.ingrLabel.text!)
				ingredientTable.deleteRows(at: [indexPath], with: .fade)
			}
			if tableView == self.directionTable {
				directions.remove(at: indexPath.row)
				directionTable.deleteRows(at: [indexPath], with: .fade)
			}
			if tableView == self.tagTable   {
				let currentCell = tableView.cellForRow(at: indexPath)! as! TagCellTableViewCell
				ingredients.removeValue(forKey: currentCell.tagName.text!)
				tagTable.deleteRows(at: [indexPath], with: .fade)
			}
		}
	}
	
	// MARK: Navigation
	
	// when the cancel recipe button is hit
	@IBAction func cancelRecipe(_ sender: UIBarButtonItem) {
		recipeTitle.text = ""
		ingrName.text = ""
		ingrAmt.text = ""
		ingrUnit.text = ""
		direction.text = ""
		ingredients.removeAll()
		directions.removeAll()
		tags.removeAll()
		num_newtags = 0
		self.ingredientTable.reloadData()
		self.directionTable.reloadData()
		self.tagTable.reloadData()
	}
	
	// allows the use of the camera
	@IBAction func useCamera(_ sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.camera
			imagePicker.mediaTypes = [kUTTypeImage as String]
			imagePicker.allowsEditing = false
			self.present(imagePicker,animated: true, completion: nil)
			newMedia = true
		}
	}
	
	// allows user to use camera roll
	@IBAction func useCameraRoll(_ sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
			imagePicker.mediaTypes = [kUTTypeImage as String]
			imagePicker.allowsEditing = false
			self.present(imagePicker, animated: true, completion: nil)
			newMedia = false
		}
	}
	
	// Allows user to pick an image from the camera roll
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let mediaType = info[UIImagePickerControllerMediaType] as! NSString
		
		self.dismiss(animated: true, completion: nil)
		
		if mediaType.isEqual(to: kUTTypeImage as String) {
			let image = info[UIImagePickerControllerOriginalImage]
				as! UIImage
			
			imageView.image = image
			
			if (newMedia == true) {
				UIImageWriteToSavedPhotosAlbum(image, self,
											   #selector(CameraViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
			} else if mediaType.isEqual(to: kUTTypeMovie as String) {
				// Code to support video would go here
			}
			
		}
	}
	
	// image helper function
	func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
		
		if error != nil {
			let alert = UIAlertController(title: "Save Failed",
										  message: "Failed to save image",
										  preferredStyle: UIAlertControllerStyle.alert)
			
			let cancelAction = UIAlertAction(title: "OK",
											 style: .cancel, handler: nil)
			
			alert.addAction(cancelAction)
			self.present(alert, animated: true,
						 completion: nil)
		}
	}
	
	// image picker helper function
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
	

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		if saveRecipeButton === sender as AnyObject?
		{
			let title = recipeTitle.text
			recipe = Recipe(title: title!)
			recipe?.ingredients = ingredients
			recipe?.directions = directions
			
			// Code to handle tags, including colors and unit amounts
			recipe?.image = imageView
			if num_newtags > 0  {
				for r in 0...(num_newtags-1)   {
					let ip = IndexPath(row: r, section: 0)
					print(ip)
                    
					let currentCell = tagTable.cellForRow(at: ip)! as! TagCellTableViewCell
					var success: Bool?
					if currentCell.tagName.text != ""  {
						if currentCell.tagColor.text == "" && currentCell.tagCategory.text == "" {
							success = (recipe?.addTag(newTag: currentCell.tagName.text!))!
						}
						else if currentCell.tagColor.text == ""  {
							success = recipe?.addTag(newTag: currentCell.tagName.text!, newCat: currentCell.tagCategory.text)
						}
						else if currentCell.tagCategory.text == "" {
							if currentCell.tagColor.text == "blue"  {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newColor: UIColor.blue)
							}
							else if currentCell.tagColor.text == "green" {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newColor: UIColor.green)
							}
							else if currentCell.tagColor.text == "red" {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newColor: UIColor.red)
							}
							else    {
								success = recipe?.addTag(newTag: currentCell.tagName.text!)
							}
						}
						else    {
							if currentCell.tagColor.text == "blue"  {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newColor: UIColor.blue, newCat: currentCell.tagCategory.text)
							}
							else if currentCell.tagColor.text == "green" {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newColor: UIColor.green, newCat: currentCell.tagCategory.text)
							}
							else if currentCell.tagColor.text == "red" {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newColor: UIColor.red, newCat: currentCell.tagCategory.text)
							}
							else    {
								success = recipe?.addTag(newTag: currentCell.tagName.text!, newCat: currentCell.tagCategory.text)
							}
						}
						if success == false   {
							print("error adding tags")
						}
					}
				}
			}
			
			// Clear table and text values and reload the table
			recipeTitle.text=""
			ingredients.removeAll()
			directions.removeAll()
			tags.removeAll()
			self.ingredientTable.reloadData()
			self.directionTable.reloadData()
			self.tagTable.reloadData()
		}
	}
}

