import UIKit

public protocol MovieRatingStrategy {
    var ratingServiceName: String { get }
    
    func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
}

public class RottenTomatoesClient: MovieRatingStrategy {
    public let ratingServiceName: String = "Rotten Tomatoes"
    
    public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
        let rating = "95%"
        let review = "It rocked!"
        success(rating, review)
    }
}

public class IMDbClient: MovieRatingStrategy {
    public let ratingServiceName: String = "IMDb"
    
    public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
        let rating = "3/10"
        let review = "It was terrible! The audience was throwing rotten tomatoes!"
        success(rating, review)
    }
}

/// Whenever this view controller is instantiated within the app (however that happens), you’d need to set the movieRatingClient. Notice how the view controller doesn’t know about the concrete implementations of MovieRatingStrategy. The determination of which MovieRatingStrategy to use can be deferred until runtime, and this could even be selected by the user if your app allowed that.
public class MovieRatingViewController: UIViewController {
    public var movieRatingClient: MovieRatingStrategy!
    
    @IBOutlet public var movieTitleTextField: UITextField!
    @IBOutlet public var ratingServiceNameLabel: UILabel!
    @IBOutlet public var ratingLabel: UILabel!
    @IBOutlet public var reviewLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        ratingServiceNameLabel.text = movieRatingClient.ratingServiceName
    }
    
    @IBAction public func searchButtonPressed(sender: Any) {
        guard let movieTitle = movieTitleTextField.text else { return }
            
        movieRatingClient.fetchRating(for: movieTitle, success: { [weak self] (rating, review) in
            self?.ratingLabel.text = rating
            self?.reviewLabel.text = review
        })
    }
}
