//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Avin on 5/2/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var genre_ids: Data?
    @NSManaged public var id: Int64
    @NSManaged public var original_language: String?
    @NSManaged public var adult: Bool
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int16
    @NSManaged public var backdrop_path: String?
    @NSManaged public var dateAdded: Date?

}