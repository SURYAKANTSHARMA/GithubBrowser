//
//  GitBrowserTests.swift
//  GitBrowserTests
//
//  Created by Prashant Rane
//  Copyright © 2019 prrane. All rights reserved.
//

import XCTest
@testable import GitBrowser

class GitBrowserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDataSource() {
      let json = """
        {
          "total_count": 104442,
          "items": [{
              "id": 28457823,
              "name": "freeCodeCamp",
              "full_name": "freeCodeCamp/freeCodeCamp",
              "owner": {
                "login": "freeCodeCamp",
                "id": 9892522,
                "avatar_url": "https://avatars0.githubusercontent.com/u/9892522?v=4",
                },
              "stargazers_count": 291539,
              "watchers_count": 291539,
              "forks_count": 13298,
              "description": "The https://freeCodeCamp.org open source codebase and curriculum. Learn to code and help nonprofits.",
            }]
          }
        """

      let jsonData = json.data(using: .utf8)!
      let repositoriesList = try? JSONDecoder().decode(RepositoriesList.self, from: jsonData)

      guard let datasource = repositoriesList else {
        XCTFail("Could not get valid JSON to generate `RepositoriesList`")
        return
      }

      // RepositoriesDataSource
      XCTAssert(!datasource.repositories.isEmpty)
      XCTAssert(datasource.repositories.first != nil)

      // Repository
      let repository = datasource.repositories.first!
      XCTAssert(repository.id == 28457823)
      XCTAssert(repository.starsCount == 291539)
      XCTAssert(repository.forksCount == 13298)

      XCTAssert(repository.name.elementsEqual("freeCodeCamp"))
      XCTAssert(repository.details.elementsEqual("The https://freeCodeCamp.org open source codebase and curriculum. Learn to code and help nonprofits."))

      // Owner
      XCTAssert((repository.owner.avatarURL?.absoluteString.elementsEqual("https://avatars0.githubusercontent.com/u/9892522?v=4")) ?? false)
      XCTAssert(repository.owner.userName.elementsEqual("freeCodeCamp"))
    }

}
