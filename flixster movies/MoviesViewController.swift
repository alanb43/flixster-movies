//
//  MoviesViewController.swift
//  flixster movies
//
//  Created by Alan Bergsneider on 9/25/20.
//

import UIKit
import AlamofireImage

// had to add ,UITableViewDataSource, UITableViewDelegate to line immediately below, xcode input protocol stubs (moved to lines 59 - 73)
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // variables created up here are called properties, available for the lifetime of the view controller
    
    // movies is an array of dictionaries. the () indicate that something is created
    var movies = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // this chunk of code downloads the array of movies and stores it into self.movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              
            // casting : as! [[String:Any]]
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            // Re-calls tableView functions at bottom to fetch data
            self.tableView.reloadData()
            
            // print(dataDictionary)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
        
    }
    // first cuntion is asking for number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Essentially saves memory, dequeueReusableCell reuses (when possible) off-screen cells, when not possible creates a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // check api --> api title info stored under "title" // casted as a string
        let synopsis = movie["overview"] as! String // api synopsis stored under "overview", again casted
        
        cell.titleLabel!.text = title
        cell.synopsisLabel!.text = synopsis
        
        
        // For poster configuration, consult API configuration. Here, w185 chosen for pixel width of 185 (by me)
        let baseUrl = "https://image.tmdb.org/t/p/w200"
        let posterPath = movie["poster_path"] as! String // consult API! poster_path in this database. still has to be a string
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
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
