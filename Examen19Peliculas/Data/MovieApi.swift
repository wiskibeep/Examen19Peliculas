import Foundation

class MovieApi {
    static let OMDB_BASE_URL = "https://www.omdbapi.com/"
    static let API_KEY = "312fdd3"
    
    static func searchMovies(by title: String) async throws -> [Movie] {
        guard let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return [] }
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&s=\(query)"
        guard let url = URL(string: urlString) else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        return response.Search ?? []
    }
    
    static func getMovieDetail(by imdbID: String) async throws -> Movie? {
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&i=\(imdbID)"
        guard let url = URL(string: urlString) else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let movie = try JSONDecoder().decode(Movie.self, from: data)
        return movie
    }
}
