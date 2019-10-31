//
//  GCDBlackBox.swift
//  On The Map
//
//  Created by Brittany Mason on 10/13/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

// MARK: -- Perform Updates to Main Method
/***************************************************************/

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

