//
//  Post.swift
//  FirstCourseFinalTask
//
//  Created by Konstantins Belcickis on 05/01/2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

public struct Post: PostProtocol {
    public var id: PostProtocol.Identifier
    public var author: GenericIdentifier<UserProtocol>
    public var description: String
    public var imageURL: URL
    public var createdTime: Date
    public var currentUserLikesThisPost: Bool
    public var likedByCount: Int
}
