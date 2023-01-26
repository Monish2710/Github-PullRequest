//
//  APIClient.swift
//  GitHub-PullRequest
//
//  Created by Monish Kumar on 22/01/23.
//

import UIKit

struct APIClient {
    static func getGitDetails(page: Int, per_page: Int = 10) async throws -> Response? {
        let apiUrl = URL(string: "https://api.github.com/repos/apple/swift/pulls?page=\(page)&per_page=\(per_page)")
        guard let urlValue = apiUrl else {
            return nil
        }
        let request = URLRequest(url: urlValue)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(Response.self, from: data)
        return response
    }
}
