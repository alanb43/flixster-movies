//
//  MovieGridViewController.swift
//  flixster movies
//
//  Created by Alan Bergsneider on 10/3/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Initialize a layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //Get it to do what i want
        layout.minimumLineSpacing = 10 // pixel space between rows of items
        layout.minimumInteritemSpacing = 7 // pixel space between items / columns
        // this changes depending on the size of the device the user is using, / 3 for 3 items
            // let width = view.frame.size.width / 3
            // in order to do so, we have to change interItemSpacing to 0, because width of the device does not account for this spacing.
        // left above for notes, below displays accounting for interitem spacing so it doesn't have to be 0 in line 29
        let width = (view.frame.size.width - (layout.minimumInteritemSpacing * 2)) / 3 // *2 because 2 spaces between 3 images
        
        layout.itemSize = CGSize(width: width, height: width * 3 / 2) // we want height to be 1.5x width
        // layout done
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
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
            
            self.collectionView.reloadData()

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
