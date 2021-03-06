//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Erik Villavera on 10/12/20.
//

import UIKit
import CoreLocation
import CoreData

class LocationDetailsViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    
    var date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func done(){
        //navigationController?.popViewController(animated: true)
//        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
//        hudView.text = "Tagged"
//        afterDelay(0.6, run:{
//            hudView.hide()
//            self.navigationController?.popViewController(animated: true)
//        })
        //1
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        hudView.text = "Tagged"
        let location = Location(context: managedObjectContext)
        //2
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        //3
        do{
            try managedObjectContext.save()
            afterDelay(0.6){
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        }catch {
            //4
            fatalCoreDataError(error)
        }
    }

    @IBAction func cancel(){
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = ""
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        dateLabel.text = format(date: date)
        
        if let placemark = placemark{
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date: Date())
        
        // Hide keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath != nil && indexPath!.section == 0{
            return
        }
        descriptionTextView.resignFirstResponder()
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var text = ""
        
        if let s = placemark.subThoroughfare {
            text += s + " "
        }
        if let s = placemark.thoroughfare{
            text += s + ", "
        }
        if let s = placemark.locality{
            text += s + ", "
        }
        if let s = placemark.administrativeArea{
            text += s + " "
        }
        if let s = placemark.postalCode{
            text += s + ", "
        }
        if let s = placemark.country{
            text += s
        }
        return text
    }
    
    func format(date: Date)-> String{
        print("Format func")
        return dateFormatter.string(from: date)
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory"{
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        print("Clicked category")
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
}
