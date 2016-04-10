//
//  Account.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

// MARK: Account

struct Account {
    
    struct Keys {
        static let FirstName = UdacityClient.UserKeys.FirstName
        static let LastName = UdacityClient.UserKeys.LastName
        static let Key = UdacityClient.UserKeys.Key
    }
    
    typealias FirstNameType = String
    typealias LastNameType = String
    typealias KeyType = String

    var firstName: FirstNameType?
    var lastName: LastNameType?
    var key: KeyType?

    init(dictionary: [String:AnyObject]) {
        
        firstName = dictionary[Keys.FirstName] as? FirstNameType
        lastName = dictionary[Keys.LastName] as? LastNameType
        key = dictionary[Keys.Key] as? KeyType
    }
    
}


// MARK: - Account: Equatable

extension Account: Equatable {}


// MARK: - Overloaded Operators
func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs.key == rhs.key
}
