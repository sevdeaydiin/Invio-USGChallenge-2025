//
//  ViewState.swift
//  Invio-USGChallenge-2025
//
//  Created by Sevde Aydın on 4/7/25.
//

import Foundation

enum ViewState: Equatable {
    //case idle
    case loading
    case noData
    case showData
    case error(String)
}
