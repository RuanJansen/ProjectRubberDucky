//
//  MockFilmsCaller.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/06/24.
//

import Foundation

class MockFilmCaller {
    func fetchCodableDataModel() async throws -> [MockFilmsCodableModel]? {
        let type = [MockFilmsCodableModel].self
        let fileName = "MockFilms"
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: url)
            let result = try await DataDecoder.decode(data, to: type)
            return result
        } else {
            return nil
        }
    }
}
