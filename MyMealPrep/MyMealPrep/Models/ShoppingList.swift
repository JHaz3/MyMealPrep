//
//  ShopingList.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/25/21.
//

import Foundation

class ShoppingList: Codable {
    
    var item: String
    var isChecked: Bool
    
    init(item: String, isChecked: Bool = false) {
        self.item = item
        self.isChecked = isChecked
    }
}// End of Class

extension ShoppingList: Equatable {
    static func == (lhs: ShoppingList, rhs: ShoppingList) -> Bool {
        return lhs.item == rhs.item
            && lhs.item == rhs.item
    }
}

