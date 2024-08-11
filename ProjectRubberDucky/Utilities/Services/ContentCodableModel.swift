//
//  ContentCodableModel.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/08/09.
//

import Foundation

struct ManifestCodableModel: Codable {
    let entityName: String
    let version: String
    let content: [ContentCodableModel]
}

struct ContentCodableModel: Codable {
    let id: String
    let description: String
}
