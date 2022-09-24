//
//  movieGridViewController.swift
//  Flix
//
//  Created by Yunior Sanchez on 9/22/22.
//

import UIKit
import AlamofireImage

class movieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 1
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 50) / 3
        
        layout.itemSize = CGSize(width: width, height: width * 2 / 1)
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/453395/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                self.collectionView.reloadData()
                print(dataDictionary)
                
                
            }
            
        }
        task.resume()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        
        let movie = movies[indexPath.item]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
            
        
        let secureBaseUrl = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: secureBaseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
//        cell.posterView.image = poster
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Find the selected movies
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        let movie = movies[indexPath.item]
        
        
        //pass the seleted movie to the details view
        
        let detailsGridViewController = segue.destination as! deteailsGridViewController
        
        detailsGridViewController.movie = movie
        
    
    
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
