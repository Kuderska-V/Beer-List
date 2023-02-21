//
//  DetailViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 10.07.2022.
//

import UIKit
import Kingfisher
import CoreData
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var imageBeer: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionBeer: UITextView!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet weak var scroller: UIScrollView!
    
    var beer: Beer!
 
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBeerDatails()
        title = beer.name
        let url = URL(string: beer.image_url)
        imageBeer.kf.setImage(with: url)
        nameLabel.text = beer.name
        yearLabel.text = beer.first_brewed
        let favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: isAddedToFavourites() ? "star.fill" : "star"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
        
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        determineCurrentLocation()
        addBeerPin()
    }
    


    func fetchBeerDatails() {
        let url = URL(string: "https://api.punkapi.com/v2/beers/\(beer.id)")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                self.beer = beers.first
                DispatchQueue.main.async {
                    self.displayDetails()
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        task.resume()
    }
    
    func displayDetails() {
        taglineLabel.text = beer?.tagline
        descriptionBeer.text = beer?.description
    }

    @objc func toggleFavorite() {
        if isAddedToFavourites() {
            remove()
        } else {
            save()
        }
    }
    
    func isAddedToFavourites() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue) as? String else { return false }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Beer")
        fetchRequest.predicate = NSPredicate(format: "id == %d && owner_email = %@" , beer.id, email)
        let count = try? managedContext.count(for: fetchRequest)
        guard let count = count else { return false }
        return count > 0
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue) as? String else { return }
        beer.ownerEmail = email
        let entity = NSEntityDescription.entity(forEntityName: "Beer", in: managedContext)!
        _ = Beer.toManagedObject(beer: beer, entity: entity, context: managedContext)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
    }
    
    func remove() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Beer")
        fetchRequest.predicate = NSPredicate(format: "id == %d" , beer.id)
        let beers = try? managedContext.fetch(fetchRequest)
        guard let beers = beers else { return }
        for beer in beers {
            managedContext.delete(beer)
        }
        try? managedContext.save()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
    }
    
    @IBAction func tapGetDirection(_ sender: UIButton) {
        openGoogleMap()
    }
    
}


extension DetailViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            let lat = currentLocation?.coordinate.latitude
            let lon = currentLocation?.coordinate.longitude
            let center = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addBeerPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 48.9232, longitude: 24.7381)
        pin.title = beer.name
        mapView.addAnnotation(pin)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }

    func openGoogleMap() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 48.9232, longitude: 24.7381), addressDictionary: nil))
        mapItem.name = beer.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

}

