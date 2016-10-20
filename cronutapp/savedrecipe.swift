//
//  savedrecipe.swift
//  cronutapp
//
//  Created by Aditi Nataraj on 10/20/16.
//  Copyright © 2016 cronut. All rights reserved.
//

import UIKit

class Savedrecipe {
    //MARK: Properties 
    
    var name: String
    var photo: UIImage?
    
    init?(name: String, photo: UIImage?) {
        self.name = name
        self.photo = photo
        if name.isEmpty {
            return nil
        }
    }
}
