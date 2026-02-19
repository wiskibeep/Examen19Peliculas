import UIKit



class MovieViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var YearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.Title
        YearLabel.text = movie.Year
        
        //Aplicar extension de IMageView del repositorio de git 
        posterImageView.loadFrom(url: movie.Poster)
    }
}
