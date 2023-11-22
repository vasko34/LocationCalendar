import UIKit
import CoreLocation

class ViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet var textViewContainer: UIView!
    var locationManager: CLLocationManager?
    var days = [Day]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location Calendar"
        navigationController?.navigationBar.tintColor = .black
        
        performSelector(inBackground: #selector(loadDaysData), with: nil)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Day", for: indexPath)
        cell.textLabel?.text = days[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Map") as? MapViewController {
            vc.selectedLocations = days[indexPath.row].locations
            vc.nameForTitle = days[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .authorizedAlways:
            break
        default:
            let ac = UIAlertController(title: "Warning!", message: "This app needs to always track your location. If you want to use this app go to 'Settings/Privacy & Security/Location Services/LocationCalendar' and press 'Always'.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "I understand", style: .default))
            present(ac, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let newLocation = Location(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            let newDay = Day(date: Date.now)
            for day in days {
                if day.name == newDay.name {
                    for location in day.locations {
                        if location.latitude == newLocation.latitude && location.longitude == newLocation.longitude {
                            return
                        }
                    }
                    day.locations.append(newLocation)
                    saveDaysData()
                    tableView.reloadData()
                    return
                }
            }
            newDay.locations.append(newLocation)
            days.insert(newDay, at: 0)
            saveDaysData()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func saveDaysData() {
        let defaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        
        if let savedDaysData = try? jsonEncoder.encode(days) {
            defaults.setValue(savedDaysData, forKey: "days")
        }
    }
    
    @objc func loadDaysData() {
        let defaults = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        
        if let daysDataToLoad = defaults.object(forKey: "days") as? Data {
            do {
                days = try jsonDecoder.decode([Day].self, from: daysDataToLoad)
            } catch {
                print("Failed to load days data.")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            if let days = self?.days {
                if !days.isEmpty {
                    self?.textViewContainer.isHidden = true
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

