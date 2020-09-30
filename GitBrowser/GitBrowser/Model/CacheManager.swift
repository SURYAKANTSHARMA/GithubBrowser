//
//  CacheManager.swift
//  GitBrowser
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
//

import UIKit

class CacheManager {

  struct Constants {
    // Cache Names
    static let kRepositoriesCacheName = "RepositoriesCache"
    static let kReadmeURLCacheName = "ReadmeURLCache"
    static let kReadmeDataCacheName = "ReadmeDataCache"
    static let kAvatarCacheName = "AvatarCache"

    // Cache Keys
    static let kRepositoriesDataSourceKey = "RepositoriesDataSource"
  }

  static let shared = CacheManager()

  private let repositoriesCache = Cache<String, RepositoriesList>(withName: Constants.kRepositoriesCacheName)
  private let readmeURLCache = Cache<Int, String>(withName: Constants.kReadmeURLCacheName)
  private let readmeDataCache = Cache<Int, Data>(withName: Constants.kReadmeDataCacheName)
  private let avatarCache = Cache<Int, Data>(withName: Constants.kAvatarCacheName)

  func repositoriesListViewModelDatasource(_ completion: @escaping (([RepositoriesListViewModel]) -> Void)) {

    guard let repositoriesDatasource = repositoriesCache.object(forKey: Constants.kRepositoriesDataSourceKey) else {

      NetworkManager().fetchTrendingRepositories({ [weak self] (datasource: RepositoriesList?) in

        if let datasource = datasource {
          self?.repositoriesCache.setObject(datasource, forKey: Constants.kRepositoriesDataSourceKey)
        }
        completion(datasource?.repositoryListViewModelDataSource() ?? [])
      })

      return
    }

    completion(repositoriesDatasource.repositoryListViewModelDataSource())
  }

  func avatarImage(for repositoryID: Int, avatarSourceURL: URL, _ completion: @escaping ((UIImage?) -> Void)) {

    guard let avatarImageData = avatarCache.object(forKey: repositoryID) else {

      NetworkManager().fetchAvatar(from: avatarSourceURL, { [weak self] (data: Data?) in

        if let imageData = data {
          self?.avatarCache.setObject(imageData, forKey: repositoryID)
          completion(UIImage(data: imageData))
        }
        else {
          completion(nil)
        }
      })

      return
    }

    completion(UIImage(data: avatarImageData))
  }

  private func readmeURL(for repositoryID: Int, readmeSourceURL: URL, _ completion: @escaping ((String?) -> Void)) {

    guard let readmeFileURL = readmeURLCache.object(forKey: repositoryID) else {

      NetworkManager().fetchReadmeURL(from: readmeSourceURL, { [weak self] (result: String?) in

        if let readmeURLString = result {
          self?.readmeURLCache.setObject(readmeURLString, forKey: repositoryID)
        }
        completion(result)
      })

      return
    }

    completion(readmeFileURL)
  }

  func readmeData(for repositoryID: Int, readmeSourceURL: URL, _ completion: @escaping ((Data?) -> Void)) {

    readmeURL(for: repositoryID, readmeSourceURL: readmeSourceURL) { [weak self] (readmeURLString: String?) in
      guard let urlString = readmeURLString, let readmeURL = URL(string: urlString) else {
        print("Error: Could not download readme data, failed to get the readme url")
        completion(nil)
        return
      }

      let cachedReadmeData = self?.readmeDataCache.object(forKey: repositoryID)
      // Return cached data initially, if available
      if let _ = cachedReadmeData {
        completion(cachedReadmeData)
      }

      // Fetch latest data and return if cached and fresh data differs
      NetworkManager().fetchReadmeData(from: readmeURL, { [weak self] (result: Data?) in

        if let downloadedReadmeData = result {
          self?.readmeDataCache.setObject(downloadedReadmeData, forKey: repositoryID)

          // Make sure we do not reload the webview if it's not changed
          if downloadedReadmeData != cachedReadmeData {
            completion(result)
          }
        }
        else {
          completion(result)
        }

      })
    }

  }

  func repositoryDetailsViewModel(for repositoryID: Int) -> RepositoryDetailsViewModel? {
    guard let repositoriesDatasource = repositoriesCache.object(forKey: "RepositoriesDataSource") else {
      return nil
    }

    return repositoriesDatasource.repositoryDetailsViewModel(for: repositoryID)
  }

}
