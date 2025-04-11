//
//  Decodable.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/11/25.
//

import Foundation

extension Decodable {
    static func decode(from data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
