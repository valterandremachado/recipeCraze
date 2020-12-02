import UIKit

//let weekdaySet = [7, 1]
//
//for days in weekdaySet {
//
//    var dateInfo = DateComponents()
//    dateInfo.hour = 16
//    dateInfo.minute = 44
//    dateInfo.weekday = days
//    dateInfo.timeZone = .current
//
//
//    print(days)
//} // End of loop



var item = "initial value" {
    didSet { //called when item changes
        print("changed")
        item
    }
    willSet {
        print("about to change")
        item
    }
}
item = "p"

