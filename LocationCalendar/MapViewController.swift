import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    var selectedLocations = [Location]()
    var nameForTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nameForTitle = self.nameForTitle {
            title = nameForTitle
        }
        
        for location in selectedLocations {
            mapView.addAnnotation(location)
        }
    }
}
