//
//  ViewModels.swift
//  GitBrowser
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
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
