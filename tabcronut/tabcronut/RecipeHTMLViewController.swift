//
//  RecipeHTMLViewController.swift
//  tabcronut
//
//  Created by Nico Verbeek on 11/15/16.
//  Copyright © 2016 Cronut LLC. All rights reserved.
//

import UIKit
import MessageUI

class RecipeHTMLViewController: UIViewController {

	@IBOutlet weak var webPreview: UIWebView!

	// var invoiceInfo: [String: AnyObject]!
	var recipeInfo: [String: AnyObject]!
	
	// var invoiceComposer: InvoiceComposer!
	var recipeComposer: RecipeComposter!
	
	var HTMLContent: String!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	*/

	// MARK: IBAction Methods
	
	
	@IBAction func exportToPDF(_ sender: AnyObject) {
		// invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
		recipeComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
		showOptionsAlert()
	}
	
	
	// MARK: Custom Methods
	
	// func createInvoiceAsHTML() {
	//  invoiceComposer = InvoiceComposer()
	//  if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: invoiceInfo["invoiceNumber"] as! String,
	//                                                     invoiceDate: invoiceInfo["invoiceDate"] as! String,
	//                                                     recipientInfo: invoiceInfo["recipientInfo"] as! String,
	//                                                     items: invoiceInfo["items"] as! [[String: String]],
	//                                                     totalAmount: invoiceInfo["totalAmount"] as! String) {
			
	//      webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
	//      HTMLContent = invoiceHTML
	//  }
	// }
	func createRecipeAsHTML() {
		recipeComposer = RecipeComposter()
		if let recipeHTML = recipeComposer.renderRecipe(name: String,
														ingredients: recipeInfo["ingredients"] as! [String: (Float, String)],
														directions: recipeInfo["directions"] as! [String])
		{
			webPreview.loadHTMLString(recipeHTML, baseURL: NSURL(string: recipeComposer.pathToRecipeHTMLTemplate!)! as URL)
			HTMLContent = recipeHTML
		}

		// if let recipeHTML = recipeComposer.renderRecipe(invoiceNumber: recipeInfo["invoiceNumber"] as! String,
		//                                                    invoiceDate: recipeInfo["invoiceDate"] as! String,
		//                                                    recipientInfo: recipeInfo["recipientInfo"] as! String,
		//                                                    items: recipeInfo["items"] as! [[String: String]],
		//                                                    totalAmount: recipeInfo["totalAmount"] as! String)
		// {
		//     webPreview.loadHTMLString(recipeHTML, baseURL: NSURL(string: recipeComposer.pathToRecipeHTMLTemplate!)! as URL)
		//     HTMLContent = recipeHTML
		// }
	}
	
	
	// Not useful for the time being:
	func showOptionsAlert() {
		let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertControllerStyle.alert)
		
		let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertActionStyle.default) { (action) in
			if let filename = self.recipeComposer.pdfFilename, let url = URL(string: filename) {
				let request = URLRequest(url: url)
				self.webPreview.loadRequest(request)
			}
		}
		
		let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertActionStyle.default) { (action) in
			DispatchQueue.main.async {
				self.sendEmail()
			}
		}
		
		let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertActionStyle.default) { (action) in
			
		}
		
		alertController.addAction(actionPreview)
		alertController.addAction(actionEmail)
		alertController.addAction(actionNothing)
		
		present(alertController, animated: true, completion: nil)
	}
	
	
	
	func sendEmail() {
		if MFMailComposeViewController.canSendMail() {
			let mailComposeViewController = MFMailComposeViewController()
			mailComposeViewController.setSubject("Invoice")
			mailComposeViewController.addAttachmentData(NSData(contentsOfFile: recipeComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
			present(mailComposeViewController, animated: true, completion: nil)
		}
	}
}
