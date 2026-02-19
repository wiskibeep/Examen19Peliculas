import Foundation

struct MovieSearchResponse: Codable {
    let Search: [Movie]?
    let totalResults: String?
    let Response: String
    let Error: String?
}

struct Movie: Codable {
    let imdbID: String
    let Title: String
    let Year: String
    let Poster: String
    let Genre: String?
    let Director: String?
    let Country: String?
    let Runtime: String?
    let Plot: String?
}
