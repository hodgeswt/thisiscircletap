//
//  LevelData.swift
//  this is circle tap
//
//  Created by Will Hodges on 11/29/21.
//

import Foundation

struct LevelData: Decodable {
    let name: String
    let balls: [Int]
    let scales: [Float]
    let colors: [String]
    let positions: [[Int]]
    let sizes: [Int]
}
