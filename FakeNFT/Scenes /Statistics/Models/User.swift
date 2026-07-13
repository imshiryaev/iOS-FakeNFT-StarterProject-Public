//
//  User.swift
//  FakeNFT
//
import Foundation

struct User: Codable {
    let name: String
    let avatar: URL
    let description: String?
    let website: URL?
    let nfts: [UUID]
    let rating: Int
    let id: UUID
}
