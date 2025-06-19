//
//  Mo.swift
//  DemoTestApp
//
//  Created by Dimpy Patel on 19/06/25.
//


import UIKit

class StoreData: Codable {
    var id: Int?
    var title: String?
    var price: Double?
    var description: String?
    var category: String?
    var image: String?
    var rating: RatingDataModel?
    
}


class RatingDataModel: Codable {
    var rate: Double?
    var count: Int?
}
