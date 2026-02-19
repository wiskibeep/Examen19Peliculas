import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    
    var originalMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    // busqueda inicial de ejemplo
    var currentQuery: String = "Guardians"
    var currentPage: Int = 1
    var hasMore: Bool = true
    var isLoading: Bool = false

    private var searchController: UISearchController!
    private var searchTimer: Timer?
    private var totalResults: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // controlador de busqueda
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        // recargar search
        navigationItem.searchController = searchController
        
        tableView.dataSource = self
        tableView.delegate = self
        // Carga inicial para mostar 10 paginas con "Guardians"
        
        searchMovies(query: currentQuery, page: 1, reset: true)
    }

    
    // Buscar movie
    func searchMovies(query: String, page: Int, reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            let (newMovies, total) = try await MovieApi.searchMoviesWithCount(by: query, page: page)
            DispatchQueue.main.async {
                if reset {
                    // filtrar pelis por nombre
                    self.filteredMovies = newMovies
                    self.totalResults = total
                    // regresqr total de movies
                    if page == 1 && query == self.currentQuery && self.originalMovies.isEmpty {
                        self.originalMovies = newMovies
                    }
                } else {
                    self.filteredMovies += newMovies
                }
                self.hasMore = self.filteredMovies.count < self.totalResults
                self.isLoading = false
                self.currentPage = page
                self.currentQuery = query
                // recargar table view
                self.tableView.reloadData()
            }
        }
    }

    // Actualizar busqueda para mostrar los vaolres del inicio
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()
        
        let newText = searchController.searchBar.text ?? ""
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            if newText.isEmpty {
                self.filteredMovies = self.originalMovies
                self.tableView.reloadData()
            } else if newText != self.currentQuery {
                self.searchMovies(query: newText, page: 1, reset: true)
            }
        }
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        if query.isEmpty {
            filteredMovies = originalMovies
            tableView.reloadData()
        } else {
            searchMovies(query: query, page: 1, reset: true)
        }
    }
    
    //cancelar search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies = originalMovies
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        let movie = filteredMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    
    
    
    
    
    // pedirm mas pag de table
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if hasMore && !isLoading && indexPath.row == filteredMovies.count - 1 && !(searchController.searchBar.text?.isEmpty ?? true) {
            searchMovies(query: currentQuery, page: currentPage + 1)
        }
    }

    // direcionamiento hacia la view de DetailViewController con los datos selecionados
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let movie = filteredMovies[indexPath.row]
        detailViewController.movie = movie
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
