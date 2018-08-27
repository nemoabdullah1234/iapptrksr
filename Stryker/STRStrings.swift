let Kbase_url = "http://strykerapi.nicbitqc.ossclients.com"//"https://strykerapi.nicbit.com" //

let Kbase_url_front = "http://stryker-traquer.nicbitqc.ossclients.com"

var mapUrl = "http://stryker-traquer.nicbit.ossclients.com/cases/locationmap?caseNo="
 
let typeofOS = "ios"


let buildIdentifer =  "Prod" //"QC" //


enum applicationType {
    case salesRep, warehouseOwner
}


struct applicationEnvironment {
    static var ApplicationCurrentType = applicationType.salesRep
}



enum TextMessage:String {
    case alert = ""
    case tryAgain = "Try again"
    case Ok = "OK"
    case enterValues = "Please enter values"
    case enterUserName = "Please enter username"
    case enterPassword = "Please enter password"
    case emailValid = "Please enter valid email"
    case phonenumber = "Please enter valid email. "
    case entertoken = "Please enter token"
    case validtoken = "Please enter valid token"
    case newpassword = "Please enter new password"
    case confirmpassword = "Password and confirm password did not match"
    case emailsend = "Code has been send to registered email."
    case noDataFound = "No Data Found"
    case used = "Used"
    case unused = "Unused"
    case notValidNumber = "Invalid Phone Number"
    case fillCity =  "Please fill City"
    case fillCountry = "Please Select Country"
    case fillPhone = "Please enter valid phone number"
    case fillFirstName = "Please fill First Name"
    case fillLastName = "Please fill Last Name"
    case casenotAssigned = "This Case does not belongs to you"
    
}


enum SettingSectionMessage : String {
    case DashboardDefaultView = "Dashboard Default View"
    case DashboardSortedBy = "Dashboard Sort By"
    case DashboardSortedOrder = "Dashboard Sort Order"
    case Notification = "Notifications"
    
}


enum TitleName : String {
    case ItemLocator = "Item Locator"
    case Notifications = "Notifications"
    case CaseHistory = "Case Notes"
    case Settings = "Settings"
    case Help = "FAQ"
    case About = "About"
    case Dashboard = "Dashboard"
    case ReportIssue = "Notes"
    case ItemComment = "Notes "
    case CaseHistoryDetail = "Due Back Details"
    case LocationInventory = "Inventory"
     case LocationInventoryDetails = "Inventory Details"
    case ChooseLocation = "Change Location"
   
}
var sortDataPopUp = ["ETD","Case No","Hospital","Doctor","Surgery Type","Surgery Date"]
var sortDataFromApi = ["ETD","CaseNo","Hospital","Doctor","SurgeryType","SurgeryDate"]

enum DashboardTitle : String {
    case All = "All"
    case alert = "Alerts"
    case Favorites = "Favorites"
}

enum  CaseDetailStringValue : String{
    case list = "List"
    case map = "Map"
}
enum  favoriteValue : String{
    case list = "Favorite"
    case map = "Favorited"
}

enum  ApplicationName : String{
    case appName = "Traquer"
}
enum RearSlider: String{
    case inventory = "Inventory"
    case case_history = "Due Back"
    case notification =  "Notifications"
    case settings =  "Settings"
    case help = "FAQ"
    case about =  "About"
    case logout =  "Logout"
    case item_locator = "Item Locator"
    case completeCase = "Case History"
    case sendDiagnostic = "Send Diagnostic"

}


