//
//  RecipeComposter.swift
//  tabcronut
//
// Created in order to implement PDF sharing
// 
//  Created by Nico Verbeek on 11/15/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit

class RecipeComposter: NSObject {

	// let bundleFromPath = Bundle(path: path)

	// let docPath = Bundle.main.resourcePath! + "/" + "edu.rpi.cs.tabcronut" + ".bundle"

	// let fileManager = FileManager.default
	// do {
	// 	let filesFromBundle = try fileManager.contentsOfDirector(atPath: docPath)
	// 	let pathToRecipeHTMLTemplate = 
	// 	print(filesFromBundle)
	// } catch {}

	let pathToRecipeHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")

	// let pathToRecipeHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")

	
	let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
	
	let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")
	
	let senderInfo = "Betty"
	
	let dueDate = ""
	
	let paymentMethod = "Ingredients"
	
	// Replace
	let logoImageURL = "http://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png"
	
	var invoiceNumber: String!
	
	var pdfFilename: String!

	/*** Added ***/
	var recipeName: String!
	// var 
	/*** End added ***/



	override init() {
		super.init()

		print("HELLO LOOK HERE'S THE PATH")
		print(pathToRecipeHTMLTemplate)
	}

	func renderRecipe(name: String, ingredients: [String: (Float, String)], directions: [String]) -> String!
	{
		// self.invoiceNumber = invoiceNumber
		self.recipeName = name
		
		do {
			// Load the invoice HTML template code into a String variable.
			var HTMLContent = try String(contentsOfFile: pathToRecipeHTMLTemplate!)
			
            // HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPE_NAME#", with: recipeName)

			// Replace all the placeholders with real values except for the items.
			// The logo image.
			// NEED
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
			
			// Invoice number.
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NUMBER#", with: invoiceNumber)
			
			// Invoice date.
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: invoiceDate)
			
			// Due date (we leave it blank by default).
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#DUE_DATE#", with: dueDate)
			
			// Sender info.
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: senderInfo)
			
			// Recipient info.
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: recipientInfo.replacingOccurrences(of: "\n", with: "<br>"))
			
			// Payment method.
			// NEED
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: paymentMethod)
			
			// Total amount.
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: totalAmount)
			
			// The invoice items will be added by using a loop.
			var allItems = ""
			
			// For all the items except for the last one we'll use the "single_item.html" template.
			// For the last one we'll use the "last_item.html" template.
			/*
			for i in 0..<ingredients.count {
				var itemHTMLContent: String!
				
				// Determine the proper template file.
				if i != ingredients.count - 1 {
					itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
				}
				else {
					itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
				}
				
				// Replace the description and price placeholders with the actual values.
				itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#", with: ingredients[i]["item"]!)
				
				// Format each item's price as a currency value.
				// let formattedPrice = AppDelegate.getAppDelegate().getStringValueFormattedAsCurrency(value: items[i]["price"]!)
				// itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: formattedPrice)
				
				// Add the item's HTML code to the general items string.
				allItems += itemHTMLContent
			}
			*/
			
			// Set the items.
			// HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
			
			// The HTML code is ready.
			// return HTMLContent
			
		}
		catch {
			print("Unable to open and use HTML template files.")
		}
		
		// return nil
		return HTMLContent
	}

	func renderRecipe(invoiceNumber: String, invoiceDate: String, recipientInfo: String, items: [[String: String]], totalAmount: String) -> String!
	{
		// Store the invoice number for future use.
		self.invoiceNumber = invoiceNumber
		
		do {
			// Load the invoice HTML template code into a String variable.
			var HTMLContent = try String(contentsOfFile: pathToRecipeHTMLTemplate!)
			
			// Replace all the placeholders with real values except for the items.
			// The logo image.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
			
			// Invoice number.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NUMBER#", with: invoiceNumber)
			
			// Invoice date.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: invoiceDate)
			
			// Due date (we leave it blank by default).
			HTMLContent = HTMLContent.replacingOccurrences(of: "#DUE_DATE#", with: dueDate)
			
			// Sender info.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: senderInfo)
			
			// Recipient info.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: recipientInfo.replacingOccurrences(of: "\n", with: "<br>"))
			
			// Payment method.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: paymentMethod)
			
			// Total amount.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: totalAmount)
			
			// The invoice items will be added by using a loop.
			var allItems = ""
			
			// For all the items except for the last one we'll use the "single_item.html" template.
			// For the last one we'll use the "last_item.html" template.
			for i in 0..<items.count {
				var itemHTMLContent: String!
				
				// Determine the proper template file.
				if i != items.count - 1 {
					itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
				}
				else {
					itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
				}
				
				// Replace the description and price placeholders with the actual values.
				itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#", with: items[i]["item"]!)
				
				// Format each item's price as a currency value.
				let formattedPrice = AppDelegate.getAppDelegate().getStringValueFormattedAsCurrency(value: items[i]["price"]!)
				itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: formattedPrice)
				
				// Add the item's HTML code to the general items string.
				allItems += itemHTMLContent
			}
			
			// Set the items.
			HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
			
			// The HTML code is ready.
			// return HTMLContent
			
		}
		catch {
			print("Unable to open and use HTML template files.")
		}
		
		return HTMLContent
		// return nil
	}

	func exportHTMLContentToPDF(HTMLContent: String)
	{
		let printPageRenderer = CustomPrintPageRenderer()
		
		let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
		printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
		
		let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
		
		pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber).pdf"
		pdfData?.write(toFile: pdfFilename, atomically: true)
		
		print(pdfFilename)
	}

	func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData!
	{
		let data = NSMutableData()
		
		UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
		
		UIGraphicsBeginPDFPage()
		
		printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
		
		UIGraphicsEndPDFContext()
		
		return data
	}
}
