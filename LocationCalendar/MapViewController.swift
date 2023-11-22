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
        
        setRegion()
        
        for location in selectedLocations {
            mapView.addAnnotation(location)
        }
    }
    
    func setRegion() {
        let minLat = selectedLocations.map { $0.latitude }.min() ?? 0
        let maxLat = selectedLocations.map { $0.latitude }.max() ?? 0
        let minLon = selectedLocations.map { $0.longitude }.min() ?? 0
        let maxLon = selectedLocations.map { $0.longitude }.max() ?? 0
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}
