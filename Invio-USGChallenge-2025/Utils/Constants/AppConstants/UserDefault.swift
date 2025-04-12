//
//  UserDefault.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/9/25.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    let container: UserDefaults
    
    init(
        key: String,
        defaultValue: Value,
        container: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
    
    var wrappedValue: Value {
        get {
            if let valueType = Value.self as? Decodable.Type,
               let data = container.data(forKey: key),
               let decoded = try? valueType.decode(from: data) as? Value {
                return decoded
            } else if let object = container.object(forKey: key) as? Value {
                return object
            }
            return defaultValue
        }
        set {
            if let codable = newValue as? Encodable {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(AnyEncodable(codable)) {
                    container.set(encoded, forKey: key)
                    return
                }
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }
}
