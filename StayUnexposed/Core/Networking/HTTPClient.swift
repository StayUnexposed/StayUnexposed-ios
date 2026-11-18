import Foundation

/// Minimal HTTP abstraction so features can be exercised without a network.
protocol HTTPClient: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        return (data, httpResponse)
    }

    func decode<T: Decodable>(_ type: T.Type, from request: URLRequest) async throws -> T {
        let (data, response) = try await send(request)
        guard (200..<300).contains(response.statusCode) else {
            throw APIError.statusCode(response.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(String(describing: error))
        }
    }
}

/// Builds requests from a path plus optional query items.
struct Endpoint {
    var baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    var path: String
    var method: String = "GET"
    var queryItems: [URLQueryItem] = []

    func request() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appending(path: path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

enum APIError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decoding(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The request URL could not be built."
        case .invalidResponse:
            "The server returned an unexpected response."
        case .statusCode(let code):
            "The server responded with status code \(code)."
        case .decoding(let details):
            "The response could not be decoded: \(details)"
        }
    }
}
