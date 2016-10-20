//
//  cronutappTests.swift
//  cronutappTests
//
//  Created by Aditi Nataraj on 9/13/16.
//  Copyright © 2016 cronut. All rights reserved.
//

import XCTest
@testable import cronutapp

class cronutappTests: XCTestCase {
    
    //MARK: cronutapp tests
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.
    func testRecipeInitialization() {
        let potentialItem = Savedrecipe(name: "Newest recipe", photo: nil)
        XCTAssertNotNil(potentialItem)
        // Failure cases.
        let noName = Savedrecipe(name: "", photo: nil)
        XCTAssertNil(noName, "Empty name is invalid")
    }
    
    
    
    
}
