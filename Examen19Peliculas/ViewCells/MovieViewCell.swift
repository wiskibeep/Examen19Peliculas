import UIKit

class MovieViewCell: UITableViewCell {
    
    // Título de la película a mostrar en la celda
    
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var YearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Solo redondea la imagen. Puedes cambiar el valor luego
       // posterImageView.layer.cornerRadius = 25
     //   posterImageView.clipsToBounds = true
    }

    // Configura los datos de la celda a partir del modelo Movie
    func configure(with movie: Movie) {
        titleLabel.text = movie.Title
        YearLabel.text = movie.Year
        // Aplicar extensión de ImageView para descargar la imagen de la URL
        posterImageView.loadFrom(url: movie.Poster)
    }
}
