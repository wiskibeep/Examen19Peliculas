import UIKit

class DetailViewController: UIViewController {
    var movie: Movie!
    
    // declarar vaolres que se van a mostrar
    @IBOutlet weak var MovieImageView: UIImageView!
    @IBOutlet weak var MovietitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ContextoLabel: UILabel!
    @IBOutlet weak var tiempoLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var PaisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Solo redondea la imagen. Puedes cambiar el valor luego
        MovieImageView.layer.cornerRadius = 45
        MovieImageView.clipsToBounds = true
        
        Task {
           // detalle de la pelicula                                      Id exacto de la pelicula
            if let detailMovie = try await MovieApi.getMovieDetail(by: movie.imdbID) {
                self.movie = detailMovie
                DispatchQueue.main.async {
                    //cargar
                    self.loadData()
                }
            }
        }
    }
    
    //declarar dato a cargar
    func loadData() {
        MovietitleLabel.text = movie.Title
        yearLabel.text = movie.Year
        MovieImageView.loadFrom(url: movie.Poster)
        ContextoLabel.text = movie.Plot
        tiempoLabel.text = movie.Runtime
        directorLabel.text = movie.Director
        genreLabel.text = movie.Genre
        PaisLabel.text = movie.Country
    }
    
}
