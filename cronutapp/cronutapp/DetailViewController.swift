//
//  DetailViewController.swift
//  cronutapp
//
//  Created by Aditi Nataraj on 9/13/16.
//  Copyright © 2016 cronut. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    // Mark properties
    @IBOutlet weak var RecipeNameLabel: UILabel!
    @IBOutlet weak var EditRecipeLabel: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        EditRecipeLabel.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        RecipeNameLabel.text = textField.text
    }

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
    }

}

