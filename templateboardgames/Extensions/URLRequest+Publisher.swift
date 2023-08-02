//
//  URLRequest+Publisher.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 18/07/2023.
//

import Foundation
import Combine

extension URLRequest {
    func publisher() -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: self)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
