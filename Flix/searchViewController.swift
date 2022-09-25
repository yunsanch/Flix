//
//  searchViewController.swift
//  Flix
//
//  Created by Yunior Sanchez on 9/25/22.
//

import UIKit

class searchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableViewSearch: UITableView!
    
    var movies = [[String:Any]]()
    
    

    var filteredData: [[String:Any]]!
    var searchController = UISearchController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSearch.dataSource = self
        tableViewSearch.delegate = self
    
        filteredData = movies
        
        searchController = UISearchController(searchResultsController: nil )
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = true
//        searchController.navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchBar.sizeToFit()
        tableViewSearch.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? movies : movies.filter{ movieObject in
//                return movieObject. .rangeOf (searchText, options:  ) != nil
                print(movieObject)
                if let title = movieObject["title"] as? String {
                    return title.contains(searchText)
                
                }
                return false
            }
        
            
        
        }
        tableViewSearch.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        
        let movie = filteredData    [indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        
        let secureBaseUrl = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        
        let posterUrl = URL(string: secureBaseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
//        cell.posterView.image = poster
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Find the selected movies
        let cell2 = sender as! UITableViewCell
        let indexPath = tableViewSearch.indexPath(for: cell2)!
        
        let movie = movies[indexPath.row]
        
        
        //pass the seleted movie to the details view
        
        let searchViewController = segue.destination as! searchViewController
        
//        searchViewController.movie = movie
        
        tableViewSearch.deselectRow(at: indexPath, animated: true)
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
