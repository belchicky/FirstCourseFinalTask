//
//  PostStorage.swift
//  FirstCourseFinalTask
//
//  Created by Konstantins Belcickis on 05/01/2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

public class PostsStorage: PostsStorageProtocol {
  private var posts: [Post]
  private var likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)]
  private var currentUserId: GenericIdentifier<UserProtocol>
  
  required public init(
    posts: [PostInitialData],
    likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)],
    currentUserID: GenericIdentifier<UserProtocol>
    ) {
    self.currentUserId = currentUserID
    self.likes = likes
    var newPostList = [Post]()
    
    posts.forEach{
      initialPost in
      let likedByCount = likes.filter{ $0.1 == initialPost.id }.count
      
      var currentUserLikesThisPost = true
      if (likes.first{ $0.0 == currentUserID && $0.1 == initialPost.id } == nil) {
        currentUserLikesThisPost = false
      }
      
      newPostList.append(
        Post(
          id: initialPost.id,
          author: initialPost.author,
          description: initialPost.description,
          imageURL: initialPost.imageURL,
          createdTime: initialPost.createdTime,
          currentUserLikesThisPost: currentUserLikesThisPost,
          likedByCount: likedByCount
      ))
    }
    
    self.posts = newPostList
  }

  public var count: Int {
    get {
      return self.posts.count
    }
  }
  
//-----
  public func post(with postID: GenericIdentifier<PostProtocol>) -> PostProtocol? {
    return self.posts.first{ $0.id == postID }
  }
  
//-----
  public func findPosts(by authorID: GenericIdentifier<UserProtocol>) -> [PostProtocol] {
    return self.posts.filter{ $0.author == authorID }
  }
  
//-----
  public func findPosts(by searchString: String) -> [PostProtocol] {
    return posts.filter({
      (post: PostProtocol) -> Bool in
      post.description.hasPrefix(searchString)
    })
  }
  
//-----
  public func likePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
    if (posts.first{ $0.id == postID } == nil) {
      return false
    }
    if (likes.first{ $0.0 == self.currentUserId && $0.1 == postID } != nil) {
      return true
    }
    let postIndexOptional = posts.firstIndex{ $0.id == postID }
    guard let postIndex = postIndexOptional else {
      return false
    }
    posts[postIndex].currentUserLikesThisPost = true
    likes.append((currentUserId, postID))
    return true
    
  }
  
//-----
  public func unlikePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
    if (posts.first{ $0.id == postID } == nil) {
      return false
    }
    let indexInLikeListForUnlike = likes.firstIndex{ $0.0 == currentUserId && $0.1 == postID }
    if (indexInLikeListForUnlike == nil) {
      return true
    }
    let postIndexOptional = posts.firstIndex{ $0.id == postID }
    guard let postIndex = postIndexOptional else {
      return false
    }
    posts[postIndex].currentUserLikesThisPost = false
    likes.remove(at: indexInLikeListForUnlike!)
    return true
  }
  
//-----
  public func usersLikedPost(with postID: GenericIdentifier<PostProtocol>) -> [GenericIdentifier<UserProtocol>]? {
    if (posts.first{ $0.id == postID } == nil) {
      return nil
    }
    return likes.filter{$0.1 == postID}.map{ $0.0 }
  }
}
