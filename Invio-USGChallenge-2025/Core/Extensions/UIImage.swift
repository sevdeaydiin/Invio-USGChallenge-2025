//
//  UIImage.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/6/25.
//

import Foundation
import UIKit

extension UIImage {
    var asData: Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
}
