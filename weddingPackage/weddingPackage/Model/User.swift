//
//  User.swift
//  weddingPackage
//
//  Created by NoON .. on 22/05/1443 AH.
//

import Foundation

struct User {
    var id = ""
    var firstName = ""
    var lastName = ""
    var imageUrl = ""
    var email = ""
    var city = ""
    
    init(dict:[String:Any]) {
        if let id = dict["id"] as? String,
           let firstName = dict["firstName"] as? String,
           let lastName = dict["lastName"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let city = dict["city"] as? String,
           let email = dict["email"] as? String {
            self.firstName = firstName
            self.lastName = lastName
            self.id = id
            self.email = email
            self.city = city
            self.imageUrl = imageUrl
        }
    }
}
