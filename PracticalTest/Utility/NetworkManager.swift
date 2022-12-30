//
//  NetworkManager.swift
//  PracticalTest
//
//  Created by Parth Patel on 04/11/22.
//

import Foundation
import Combine

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var method: String { get }
}

extension EndPointType {
    var baseURL: String {
        return "https://api.github.com/users"
    }
}

public enum UserModule {
    case getUserList(lastUserID: String)
    case getUserDetails(userID: String)
}

extension UserModule: EndPointType {
    var method: String {
        return "GET"
    }
    
    var path: String {
        switch self {
        case .getUserList(let lastUserID):
            return "?since=" + lastUserID
        case .getUserDetails(let userID):
            return "/" + userID
        }
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    func getData<T: Decodable>(endpoint: UserModule, id: Int? = nil, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: endpoint.baseURL.appending(endpoint.path)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            print("URL is \(url.absoluteString)")
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method
            request.httpBody = nil
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.url = url
            
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
    case internetConnection
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        case .internetConnection:
            return NSLocalizedString("No internet", comment: "No internet")
        }
    }
}
