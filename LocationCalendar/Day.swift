import UIKit

class Day: NSObject, Codable {
    var locations = [Location]()
    var date: Date
    var name: String {
        let descriptionArray = self.date.description.components(separatedBy: " ")
        let yearMonthDayArray = descriptionArray[0].components(separatedBy: "-")
        let year = yearMonthDayArray[0]
        let monthNumber = yearMonthDayArray[1]
        let day = yearMonthDayArray[2]
        let monthWord: String
        
        switch monthNumber {
        case "1":
            monthWord = "January"
        case "2":
            monthWord = "February"
        case "3":
            monthWord = "March"
        case "4":
            monthWord = "April"
        case "5":
            monthWord = "May"
        case "6":
            monthWord = "June"
        case "7":
            monthWord = "July"
        case "8":
            monthWord = "August"
        case "9":
            monthWord = "September"
        case "10":
            monthWord = "October"
        case "11":
            monthWord = "November"
        case "12":
            monthWord = "December"
        default:
            monthWord = "UNKNOWN"
        }
        
        return day + " " + monthWord + " " + year
    }
    
    init(date: Date) {
        self.date = date
    }
}
