//
//  Account.swift
//  On the Map
//
//  Created by Adland Lee on 3/24/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import Foundation

struct Account {
    
    struct Keys {
        static let firstName = UdacityClient.UserKeys.FirstName
        static let lastName = UdacityClient.UserKeys.LastName
        static let key = UdacityClient.UserKeys.Key
    }
    
    typealias FirstNameType = String
    typealias LastNameType = String
    typealias KeyType = String

    var firstName: FirstNameType?
    var lastName: LastNameType?
    var key: KeyType?

    init(dictionary: [String:AnyObject]) {
        
        firstName = dictionary[Keys.firstName] as? FirstNameType
        lastName = dictionary[Keys.lastName] as? LastNameType
        key = dictionary[Keys.key] as? KeyType
    }
    
}

// MARK: - UdacityParseStudentLocation: Equatable

extension Account: Equatable {}

func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs.key == rhs.key
}
