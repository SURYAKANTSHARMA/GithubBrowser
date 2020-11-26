//
//  ViewModels.swift
//  GitBrowser
//
//  Created by Surya
//  Copyright © 2019 Github. All rights reserved.
//


import Foundation

struct RepositoriesListViewModel {
  let repositoryID: Int
  let repoName: String
  let details: String
  let starsCount: Int
}

struct RepositoryDetailsViewModel {
  let userName: String
  let details: String
  let starsCount: Int
  let forksCount: Int
  let readmeSourceURL: URL?
  let avatarURL: URL?
  let repositoryID: Int
}
