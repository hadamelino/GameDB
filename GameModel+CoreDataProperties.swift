//
//  GameModel+CoreDataProperties.swift
//  GameDB
//
//  Created by Hada Melino on 16/05/23.
//
//

import Foundation
import CoreData


extension GameModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameModel> {
        return NSFetchRequest<GameModel>(entityName: "GameModel")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var released: String
    @NSManaged public var rating: Float
    @NSManaged public var backgroundImageURL: String

}

extension GameModel : Identifiable {

}
