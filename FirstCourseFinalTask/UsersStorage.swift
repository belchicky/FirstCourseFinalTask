//
//  UsersStorage.swift
//  FirstCourseFinalTask
//
//  Created by Konstantins Belcickis on 05/01/2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

class UsersStorage: UsersStorageProtocol {
  private var users: [User]
  private var followers: [(UserProtocol.Identifier, UserProtocol.Identifier)]
  private var currentUserId: UserProtocol.Identifier

  required public init?(
    users: [UserInitialData],
    followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)],
    currentUserID: GenericIdentifier<UserProtocol>
    ) {
    if (users.first { $0.id == currentUserID } == nil) {
      return nil
    }
    
    self.currentUserId = currentUserID
    self.followers = followers
    var newUserList = [User]()
    
    
    users.forEach{
      initialUser in
      let followsCount = followers.filter{ $0.0 == initialUser.id }.count
      let followedByCount = followers.filter{ $0.1 == initialUser.id }.count
      
      var currentUserFollowsThisUser = true
      if (followers.first{ $0.0 == currentUserID && $0.1 == initialUser.id } == nil) {
        currentUserFollowsThisUser = false
      }
      
      var currentUserIsFollowedByThisUser = true
      if (followers.first{ $0.1 == currentUserID && $0.0 == initialUser.id } == nil) {
        currentUserIsFollowedByThisUser = false
      }
      
      newUserList.append(
        User(
          id: initialUser.id,
          username: initialUser.username,
          fullName: initialUser.fullName,
          avatarURL: initialUser.avatarURL,
          currentUserFollowsThisUser: currentUserFollowsThisUser,
          currentUserIsFollowedByThisUser: currentUserIsFollowedByThisUser,
          followsCount: followsCount,
          followedByCount: followedByCount
      ))
    }
    
    self.users = newUserList
  }
  
  public var count: Int {
    get {
      return users.count
    }
  }
  
//-----
  public func currentUser() -> UserProtocol {
    return users.first{ $0.id == currentUserId }!
  }
  
//-----
  public func user(with userID: GenericIdentifier<UserProtocol>) -> UserProtocol? {
    return users.first{ $0.id == userID }
  }
  
//-----
  public func findUsers(by searchString: String) -> [UserProtocol] {
    return users.filter({
      (user: UserProtocol) -> Bool in
      user.username.hasPrefix(searchString) || user.fullName.hasPrefix(searchString)
    })
  }
  
//-----
  public func follow(_ userIDToFollow: GenericIdentifier<UserProtocol>) -> Bool {
    if (users.first{ $0.id == userIDToFollow } == nil) {
      return false
    }
    if (followers.first{ $0.0 == currentUserId && $0.1 == userIDToFollow } != nil) {
      return true
    }
    let currentUserIndexOptional = users.firstIndex{ $0.id == currentUserId }
    let userToFollowIndexOptional = users.firstIndex{ $0.id == userIDToFollow }
    guard let currentUserIndex = currentUserIndexOptional else {
      return false
    }
    guard let userToFollowIndex = userToFollowIndexOptional else {
      return false
    }
    users[currentUserIndex].followsCount += 1
    users[userToFollowIndex].followedByCount += 1
    followers.append((currentUserId, userIDToFollow))
    return true
    
  }
  
//-----
  public func unfollow(_ userIDToUnfollow: GenericIdentifier<UserProtocol>) -> Bool {
    if (users.first{ $0.id == userIDToUnfollow } == nil) {
      return false
    }
    let indexInFollowListToUnfollow = followers.firstIndex{ $0.0 == currentUserId && $0.1 == userIDToUnfollow }
    if (indexInFollowListToUnfollow == nil) {
      return true
    }
    let currentUserIndexOptional = users.firstIndex{ $0.id == currentUserId }
    let userToUnfollowIndexOptional = users.firstIndex{ $0.id == userIDToUnfollow }
    guard let currentUserIndex = currentUserIndexOptional else {
      return false
    }
    guard let userToUnfollowIndex = userToUnfollowIndexOptional else {
      return false
    }
    users[currentUserIndex].followsCount -= 1
    users[userToUnfollowIndex].followedByCount -= 1
    followers.remove(at: indexInFollowListToUnfollow!)
    return true
  }
  
//-----
  public func usersFollowingUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
    if (users.first{ $0.id == userID } == nil) {
      return nil
    }
    return users.filter({
      (user: UserProtocol) -> Bool in
      followers.first{ $0.1 == userID && $0.0 == user.id } != nil
    })
  }
  
//-----
  public func usersFollowedByUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
    if (users.first{ $0.id == userID } == nil) {
      return nil
    }
    return users.filter({
      (user: UserProtocol) -> Bool in
      followers.first{ $0.0 == userID && $0.1 == user.id } != nil
    })
  }
}
