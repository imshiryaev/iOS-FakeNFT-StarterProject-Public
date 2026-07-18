//
//  User.swift
//  FakeNFT
//
import Foundation

struct User: Codable {
    /// Имя пользователя.
    let name: String

    /// URL изображения профиля.
    let avatar: URL

    /// Описание профиля пользователя.
    let description: String?

    /// URL сайта пользователя.
    let website: URL?

    /// Идентификаторы NFT, принадлежащих пользователю.
    let nfts: [UUID]

    /// Позиция пользователя в рейтинге.
    let rating: Int

    /// Уникальный идентификатор пользователя.
    let id: UUID
}
