//
//  RandomViewController.swift
//  Beer List
//
//  Created by Vitalina Nazaruk on 12.07.2022.
//

import UIKit
import Kingfisher
import CoreData
import MapKit
import CoreLocation

class RandomViewController: UIViewController {

    @IBOutlet weak var imageRandom: UIImageView!
    @IBOutlet weak var nameRandom: UILabel!
    @IBOutlet weak var taglineRandom: UILabel!
    @IBOutlet weak var yearRandom: UILabel!
    @IBOutlet weak var descriptionRandom: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var beer: Beer?
    var favoriteButtonItem: UIBarButtonItem?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let pin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random Beer"
        imageRandom.isHidden = true
        nameRandom.isHidden = true
        yearRandom.isHidden = true
        taglineRandom.isHidden = true
        descriptionRandom.isHidden = true
        tapRandomButton(UIButton())
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        determineCurrentLocation()
    }
    
    
    func fetchRundomBeer(completion: @escaping (Beer?) -> Void) {
        let url = URL(string: "https://api.punkapi.com/v2/beers/random")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let beers = try JSONDecoder().decode([Beer].self, from: data)
                DispatchQueue.main.async {
                    completion(beers.first)
                }
            } catch {
                DispatchQueue.main.async {
                    self.presentAlert(with:AlertController.somethingWentWrong.rawValue, message: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
        
    @IBAction func tapRandomButton(_ sender: UIButton) {
        fetchRundomBeer { beer in
            self.beer = beer
            self.configureLayouts()
            self.generateAnnoLoc()
        }
    }
    
    func configureLayouts() {
        guard let beer = beer else { return }
        title = beer.name
        favoriteButtonItem = UIBarButtonItem(image: UIImage(systemName: isAddedToFavourites() ? "star.fill" : "star"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButtonItem
        imageRandom.isHidden = false
        nameRandom.isHidden = false
        yearRandom.isHidden = false
        taglineRandom.isHidden = false
        descriptionRandom.isHidden = false
        let url = URL(string: beer.image_url)
        imageRandom.kf.setImage(with: url!)
        nameRandom.text = beer.name
        yearRandom.text = beer.first_brewed
        taglineRandom.text = beer.tagline
        descriptionRandom.text = beer.description
    }
    
    @objc func toggleFavorite() {
        if isAddedToFavourites() {
            remove()
        } else {
            save()
        }
    }
    
    func isAddedToFavourites() -> Bool {
        guard let beer = beer else { return false }
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
        guard var beer = beer else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let email = UserDefaults.standard.value(forKey: UserDefaultsKeys.loggedInUserEmail.rawValue) as? String else { return }
        beer.ownerEmail = email
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Beer", in: managedContext)!
        Beer.toManagedObject(beer: beer, entity: entity, context: managedContext)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
    }
    
    func remove() {
        guard let beer = beer else { return }
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
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
        
extension RandomViewController {
    func presentAlert(with title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

extension RandomViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            let lat = currentLocation?.coordinate.latitude
            let lon = currentLocation?.coordinate.longitude
            let center = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: true)
        }
    }
    
    func generateAnnoLoc() -> CLLocationCoordinate2D  {
        pin.coordinate = generateRandomCoordinates(min: 10, max: 1000)
        pin.title = beer?.name
        mapView.addAnnotation(pin)
        return pin.coordinate
    }
    
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        let currentLong = locationManager.location?.coordinate.longitude
        let currentLat = locationManager.location?.coordinate.latitude
        let meterCord = 0.00900900900901 / 1000
        let randomMeters = UInt(arc4random_uniform(max) + min)
        let randomPM = arc4random_uniform(6)
        let metersCordN = meterCord * Double(randomMeters)
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat! + metersCordN, longitude: currentLong! + metersCordN)
        } else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong! - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat! + metersCordN, longitude: currentLong! - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong! + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong! - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
    }

    func openGoogleMap() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude), addressDictionary: nil))
        mapItem.name = beer?.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}


