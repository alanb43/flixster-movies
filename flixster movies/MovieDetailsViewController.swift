//
//  MovieDetailsViewController.swift
//  flixster movies
//
//  Created by Alan Bergsneider on 10/3/20.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        // makes label start in top left and be as large as necessary (.sizeToFit())
        synopsisLabel.sizeToFit()
        // copied from MoviesViewController
        let baseUrl = "https://image.tmdb.org/t/p/w200"
        let posterPath = movie["poster_path"] as! String // consult API! poster_path in this database. still has to be a string
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        
        let backdropPath = movie["backdrop_path"] as! String // consult API! backdrop_path in this database. still has to be a string
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        backdrop.af_setImage(withURL: backdropUrl!)
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
