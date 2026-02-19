import Foundation

/// Clase responsable de todas las llamadas a la API de OMDB.

class MovieApi {
    /// URL base de la API de OMDB.
    static let OMDB_BASE_URL = "https://www.omdbapi.com/"
    /// Clave de API personal apiKey
    static let API_KEY = "312fdd3"

    // MARK: - Búsqueda de peliculas


    static func searchMoviesWithCount(by title: String, page: Int = 1) async throws -> ([Movie], Int) {
        
        guard let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return ([], 0)
        }
        
        // pagina de busqueda
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&s=\(query)&page=\(page)"
        guard let url = URL(string: urlString) else { return ([], 0) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        let movies = response.Search ?? []
        let total = Int(response.totalResults ?? "0") ?? 0
        return (movies, total)
    }

    // MARK: - Detalle de una película


    static func getMovieDetail(by imdbID: String) async throws -> Movie? {
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&i=\(imdbID)"
        guard let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        let movie = try JSONDecoder().decode(Movie.self, from: data)
        return movie
    }
}

/*
 {
   "Title": "Interstellar",
   "Year": "2014",
   "Rated": "PG-13",
   "Released": "07 Nov 2014",
   "Runtime": "169 min",
   "Genre": "Adventure, Drama, Sci-Fi",
   "Director": "Christopher Nolan",
   "Writer": "Jonathan Nolan, Christopher Nolan",
   "Actors": "Matthew McConaughey, Anne Hathaway, Jessica Chastain",
   "Plot": "When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.",
   "Language": "English",
   "Country": "United States, United Kingdom, Canada",
   "Awards": "Won 1 Oscar. 45 wins & 148 nominations total",
   "Poster": "https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_SX300.jpg",
   "Ratings": [
     {
       "Source": "Internet Movie Database",
       "Value": "8.7/10"
     },
     {
       "Source": "Rotten Tomatoes",
       "Value": "73%"
     },
     {
       "Source": "Metacritic",
       "Value": "74/100"
     }
   ],
   "Metascore": "74",
   "imdbRating": "8.7",
   "imdbVotes": "2,472,939",
   "imdbID": "tt0816692",
   "Type": "movie",
   "DVD": "N/A",
   "BoxOffice": "$203,227,580",
   "Production": "N/A",
   "Website": "N/A",
   "Response": "True"
 }
 */
