//
//  AnyEncodable.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/11/25.
//

import Foundation

struct AnyEncodable: Encodable {
    let value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    // Forwards the encoding responsibility to the wrapped Encodable value
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
