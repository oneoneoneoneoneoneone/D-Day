//
//  Network.swift
//  D-Day
//
//  Created by hana on 2023/06/14.
//

import Foundation

class Network{
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(api: UnsplashAPI, dataType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = getURLRequest(api: api) else {
            return completion(.failure(URLError(.badURL)))
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }
            
            switch httpResponse.statusCode{
            case 200..<300:
                guard let data = data else{
                    completion(.failure(URLError(.cannotParseResponse)))
                    return
                }
                do{
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                }catch{
                    completion(.failure(URLError(.cannotDecodeRawData)))
                }
            case 400..<500:
                completion(.failure(URLError(.clientCertificateRejected)))
            case 500..<599:
                completion(.failure(URLError(.badServerResponse)))
            default:
                completion(.failure(URLError(.unknown)))
            }
        }
        .resume()
    }
    
    private func getURLRequest(api: UnsplashAPI) -> URLRequest?{
        guard let url = api.getComponents.url else{ return nil }
        NSLog("\(url)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method
        urlRequest.allHTTPHeaderFields = api.headers
        
        return urlRequest
    }
}
