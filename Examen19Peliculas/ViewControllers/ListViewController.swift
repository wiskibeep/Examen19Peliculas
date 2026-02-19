import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    
    
    @IBOutlet weak var tableView: UITableView!
    var movieList: [Movie] = []
    var currentQuery: String = "Guardians"
    var currentPage: Int = 1
    var hasMore: Bool = true
    var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        tableView.dataSource = self
        tableView.delegate = self
        searchMovies(query: currentQuery, page: 1, reset: true)
    }

    func searchMovies(query: String, page: Int, reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            let newMovies = try await MovieApi.searchMovies(by: query, page: page)
            DispatchQueue.main.async {
                if reset {
                    self.movieList = newMovies
                } else {
                    self.movieList += newMovies
                }
                self.hasMore = newMovies.count == 10 
                self.isLoading = false
                self.currentPage = page
                self.currentQuery = query
                self.tableView.reloadData()
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        searchMovies(query: query, page: 1, reset: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchMovies(query: "", page: 1, reset: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        let movie = movieList[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    // Detonador de scroll infinito
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if hasMore && !isLoading && indexPath.row == movieList.count - 1 {
            // Cargar siguiente página
            searchMovies(query: currentQuery, page: currentPage + 1)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let movie = movieList[indexPath.row]
        detailViewController.movie = movie
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
