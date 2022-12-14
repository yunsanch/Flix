//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Yunior Sanchez on 9/21/22.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    

    @IBOutlet weak var BackDropView: UIImageView!
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sipnosis: UILabel!
    
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        sipnosis.text = movie["overview"] as? String
        sipnosis.sizeToFit()
        
        let secureBaseUrl = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        
        let posterUrl = URL(string: secureBaseUrl + posterPath)
        
        posterView.af.setImage(withURL: posterUrl!)
        
        let backDropPath = movie["backdrop_path"] as! String
        
        let backdropUrl = URL(string: secureBaseUrl + backDropPath)
        BackDropView.af.setImage(withURL: backdropUrl!)
        

        // Do any additional setup after loading the view.
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
