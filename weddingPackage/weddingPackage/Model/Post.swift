//
//  Post.swift
//  weddingPackage
//
//  Created by NoON .. on 22/05/1443 AH.
//

import Foundation
import Firebase
struct Post {
    var id = ""
    var namePackage = ""
    var price = ""
    var description = ""
    var imageUrl = ""
//    var packageImage = ""
    var user:User
  var createdAt:Timestamp?
    
    init(dict:[String:Any],id:String,user:User) {
        if let namePackage = dict["name Package"] as? String,
           let description = dict["description"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
//           let packageImage = dict["package Image"] as? String,
           let price = dict["price"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp{
           self.namePackage = namePackage
            self.description = description
            self.imageUrl = imageUrl
            self.price = price
//            self.packageImage = packageImage
         self.createdAt = createdAt
        }
        self.id = id
        self.user = user
    }
}
