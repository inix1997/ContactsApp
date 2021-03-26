//
//  UserData.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 26/03/2021.
//

import UIKit

class UserData: NSObject {

    static let sharedInstance = UserData()
    
    var savedSortedResultsArray = [Contact]()
    var savedSortedFavouritesResultsArray = [Contact]()

}
