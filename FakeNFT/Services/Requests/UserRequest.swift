//
//  UserRequest.swift
//  FakeNFT
//

import Foundation

struct UserRequest: NetworkRequest {
    let page: Int
    let size: Int
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)")
    }
    var dto: Dto?
    
}
