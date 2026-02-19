import Foundation

class MovieApi {
    static let OMDB_BASE_URL = "https://www.omdbapi.com/"
    static let API_KEY = "312fdd3"

    // Busca películas y devuelve (películas, total de resultados)
    static func searchMoviesWithCount(by title: String, page: Int = 1) async throws -> ([Movie], Int) {
        guard let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return ([], 0) }
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&s=\(query)&page=\(page)"
        guard let url = URL(string: urlString) else { return ([], 0) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        let movies = response.Search ?? []
        let total = Int(response.totalResults ?? "0") ?? 0
        return (movies, total)
    }

    // Ya deberías tener este:
    static func getMovieDetail(by imdbID: String) async throws -> Movie? {
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&i=\(imdbID)"
        guard let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        let movie = try JSONDecoder().decode(Movie.self, from: data)
        return movie
    }
}
