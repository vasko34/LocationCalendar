import UIKit

class Day: NSObject, Codable {
    var locations = [Location]()
    var date: Date
    var name: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self.date)
    }
    
    init(date: Date) {
        self.date = date
    }
}
