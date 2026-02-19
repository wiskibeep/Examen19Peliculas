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
        // podra buscar la pelicula pero no con todos los datos, solo:
        /*
         {
           "Title": "Interstellar",
           "Year": "2014",
           "imdbID": "tt0816692",
           "Type": "movie",
           "Poster": "..."
         }
         y nos podemos ahorrar data y no sobre cargar el servidor, ademas de no tomar tados iniecesarios
         
         */
        
        // pagina de busqueda                 apiKey  !S=!!  !!Nombre a buscar!!  pag que va
        let urlString = "\(OMDB_BASE_URL)?apikey=\(API_KEY)&s=\(query)&page=\(page)"
        // devolvera un
        guard let url = URL(string: urlString) else { return ([], 0) }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        let movies = response.Search ?? []
        let total = Int(response.totalResults ?? "0") ?? 0
        return (movies, total)
        
        // Se usa para llamr a valores cortos de llamara
    }
    
  //  una vez selecionado se coloca el id y se llama a esta funcion ImdbID pra llamar a los detalles,devolviendo todos los detalles de 
    
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
 //MARK: busqueda ejemplo:
 https://www.omdbapi.com/?apikey=312fdd3&s=batman&page=1
 
 
 {
   "Search": [
     {
       "Title": "Batman Begins",
       "Year": "2005",
       "imdbID": "tt0372784",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BMzA2NDQzZDEtNDU5Ni00YTlkLTg2OWEtYmQwM2Y1YTBjMjFjXkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "The Batman",
       "Year": "2022",
       "imdbID": "tt1877830",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzUtNjAyYmE4Njg5YWMyXkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman v Superman: Dawn of Justice",
       "Year": "2016",
       "imdbID": "tt2975590",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BZTJkYjdmYjYtOGMyNC00ZGU1LThkY2ItYTc1OTVlMmE2YWY1XkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman v Superman: Dawn of Justice",
       "Year": "2016",
       "imdbID": "tt2975590",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BZTJkYjdmYjYtOGMyNC00ZGU1LThkY2ItYTc1OTVlMmE2YWY1XkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman",
       "Year": "1989",
       "imdbID": "tt0096895",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BYzZmZWViM2EtNzhlMi00NzBlLWE0MWEtZDFjMjk3YjIyNTBhXkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman Returns",
       "Year": "1992",
       "imdbID": "tt0103776",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BZTliMDVkYTktZDdlMS00NTAwLWJhNzYtMWIwMDZjN2ViMGFiXkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman Forever",
       "Year": "1995",
       "imdbID": "tt0112462",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BMTUyNjJhZWItMTZkNS00NDc4LTllNjUtYTg3NjczMzA5ZTViXkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "Batman & Robin",
       "Year": "1997",
       "imdbID": "tt0118688",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BYzU3ZjE3M2UtM2E4Ni00MDI5LTkyZGUtOTFkMGIyYjNjZGU3XkEyXkFqcGc@._V1_SX300.jpg"
     },
     {
       "Title": "The Lego Batman Movie",
       "Year": "2017",
       "imdbID": "tt4116284",
       "Type": "movie",
       "Poster": "https://m.media-amazon.com/images/M/MV5BMTcyNTEyOTY0M15BMl5BanBnXkFtZTgwOTAyNzU3MDI@._V1_SX300.jpg"
     },
     {
       "Title": "Batman: The Animated Series",
       "Year": "1992–1995",
       "imdbID": "tt0103359",
       "Type": "series",
       "Poster": "https://m.media-amazon.com/images/M/MV5BYjgwZWUzMzUtYTFkNi00MzM0LWFkMWUtMDViMjMxNGIxNDUxXkEyXkFqcGc@._V1_SX300.jpg"
     }
   ],
   "totalResults": "632",
   "Response": "True"
 }
 
 
 //MARK: EJemplo de Detalle de pelicula
 
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
