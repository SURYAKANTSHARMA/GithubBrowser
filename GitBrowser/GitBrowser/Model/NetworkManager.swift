//
//  NetworkManager.swift
//  GitBrowser
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
//

import UIKit

class NetworkManager {

  private struct Constants {
    static let memoryCacheByteLimit: Int = 4 * 1024 * 1024 // 20 MB
    static let diskCacheByteLimit: Int = 20 * 1024 * 1024          // 4 MB
    static let cacheName: String = "GithubBrowser.cache"
  }

  static func setupURLCache() {
    guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(Constants.cacheName) else {
      assertionFailure("Failed to setup URL Cache: Can not get cache file path.")
      return
    }

    // FIXME: Setup `URLCache` such that images/webpages we are querying would be served from `URLCache` once cached
  }

}

// MARK: - Avatar

extension NetworkManager {
  
  // FIXME: implement fetchAvatar
  func fetchAvatar(from avaratURL: URL, _ completion: @escaping ((Data?) -> Void)) {
    completion(nil)
  }

}

// MARK: - Repository List

extension NetworkManager {

  func fetchTrendingRepositories(_ completion: @escaping ((RepositoriesList?) -> Void)) {
    assert(trendingProjectsURL != nil, "trendingProjectsURL should never be nil")

    guard let url = trendingProjectsURL else {
      completion(nil)
      return
    }

    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let jsonData = data else {
        print("Error: Failed to get json data, error: \(String(describing: error))")
        completion(nil)
        return
      }

      do {
        let datasource = try JSONDecoder().decode(RepositoriesList.self, from: jsonData)
        completion(datasource)
      }
      catch let error {
        print("Error: Failed to decode json data, error: \(String(describing: error))")
        completion(nil)
        return
      }

    }

    dataTask.resume()
  }

  // created or last updated: https://help.github.com/en/articles/searching-for-repositories#search-by-when-a-repository-was-created-or-last-updated
  // other options: https://developer.github.com/v3/search/#search-repositories
  private var trendingProjectsURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.github.com"
    components.path = "/search/repositories"
    
    // FIXME: Modify this query to find repos with recent code pushed (in last two days) sort by stars with most stars on top
    components.queryItems = {
      var queryItems = [URLQueryItem]()
      queryItems.append(URLQueryItem(name: "q", value: "swift"))
      return queryItems
    }()

    return components.url
  }

}

// MARK: - README

extension NetworkManager {

  // FIXME: implement fetchReadmeURL
  func fetchReadmeURL(from readmeSourceURL: URL, _ completion: @escaping ((String?) -> Void)) {
    completion(nil)
  }

  func fetchReadmeData(from readmeURL: URL, _ completion: @escaping ((Data?) -> Void)) {
    let dataTask = URLSession.shared.dataTask(with: readmeURL) { (data, response, error) in
      guard let _ = data else {
        print("Error: Failed to get readme data, error: \(String(describing: error))")
        completion(nil)
        return
      }

      completion(data)
    }

    dataTask.resume()
  }

}
