//
//  GitEntityModel+CoreDataProperties.swift
//  GitHub-PullRequest
//
//  Created by Monish Kumar on 26/01/23.
//
//

import Foundation
import CoreData


extension GitEntityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GitEntityModel> {
        return NSFetchRequest<GitEntityModel>(entityName: "GitEntityModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var userName: String?
    @NSManaged public var createdDate: String?
    @NSManaged public var updatedDate: String?
    @NSManaged public var avatarURL: String?
    @NSManaged public var htmlURL: String?

}
