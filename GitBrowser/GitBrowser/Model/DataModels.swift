//
//  DataModels.swift
//  GitBrowser
//
//  Created by Surya
//  Copyright © 2019 Github. All rights reserved.
//


import UIKit

struct RepositoriesList: Codable {
  let repositories: [Repository]

  enum CodingKeys: String, CodingKey {
    case repositories = "items"
  }
}

struct ReadMe: Decodable {
    let htmlURL: String
    
    enum CodingKeys: String, CodingKey {
      case htmlURL = "html_url"
    }
}

struct Repository: Codable {
  let id: Int
  let name: String
  let details: String // description
  let starsCount: Int //stargazers_count
  let forksCount: Int //forks_count
  let owner: Owner

  var readmeSourceURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.github.com"
    components.path = "/repos/\(owner.userName)/\(name)/readme"
    return components.url
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case details = "description"
    case starsCount = "stargazers_count"
    case forksCount = "forks_count"
    case owner
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    name = try values.decode(String.self, forKey: .name)
    details = try values.decode(String.self, forKey: .details)
    starsCount = try values.decode(Int.self, forKey: .starsCount)
    forksCount = try values.decode(Int.self, forKey: .forksCount)
    owner = try values.decode(Owner.self, forKey: .owner)
  }
}

struct Owner: Codable {
  let id: Int
  let userName: String
  let avatarURL: URL?
  
  enum CodingKeys: String, CodingKey {
    case userName = "login"
    case avatarURL = "avatar_url"
    case id
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    userName = try values.decode(String.self, forKey: .userName)
    let avatarPath = try values.decode(String.self, forKey: .avatarURL)
    avatarURL = URL(string: avatarPath)
    id = try values.decode(Int.self, forKey: .id)
  }

}

// MARK: - Hashable

extension Repository: Hashable {

  static func ==(lhs: Repository, rhs: Repository) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension RepositoriesList : Hashable {

  static func ==(lhs: RepositoriesList, rhs: RepositoriesList) -> Bool {
    return lhs.repositories == rhs.repositories
  }


  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    repositories = try values.decode([Repository].self, forKey: .repositories)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(repositories.map{$0.id})
  }
}

// MARK: - RepositoriesDataSource Helpers

extension RepositoriesList {

  func repositoryListViewModelDataSource() -> [RepositoriesListViewModel] {
    return repositories.map{
      return RepositoriesListViewModel(repositoryID: $0.id, repoName: $0.name, details: $0.details, starsCount: $0.starsCount)
    }
  }

  func repositoryDetailsViewModel(for repositoryID: Int) -> RepositoryDetailsViewModel? {
    let repository = repositories.filter{ $0.id == repositoryID}.first
    guard let repo = repository else {
      print("Error: Could not find the repository with id \(repositoryID) in cache ")
      return nil
    }

    return RepositoryDetailsViewModel(userName: repo.owner.userName, details: repo.details, starsCount: repo.starsCount, forksCount: repo.forksCount, readmeSourceURL: repo.readmeSourceURL, avatarURL: repo.owner.avatarURL, repositoryID: repo.id)
  }

}
