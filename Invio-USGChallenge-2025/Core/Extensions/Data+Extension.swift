//
//  Data+Extension.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation
import UIKit
import SwiftUI

extension Data {
    var asNSData: NSData {
        return NSData(data: self)
    }
    
    var asImage: Image {
        if let uiImage = UIImage(data: self) {
            return Image(uiImage: uiImage)
        }
        
        return .init(systemName: "photo")
    }
}

extension NSData {
    var asData: Data {
        return Data(referencing: self)
    }
}
