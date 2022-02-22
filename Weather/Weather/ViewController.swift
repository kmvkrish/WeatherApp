//
//  ViewController.swift
//  Weather
//
//  Created by Krishna Manoj Varanasi on 21/02/22.
//

import UIKit
import CoreLocation
import MBProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var currentLocationDetails: String?
    
    var items: [Weather] = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Register 2 cells
        self.tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        self.tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocationManager()
    }

    // MARK: LocationManager
    func setupLocationManager() -> Void {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            //locationManager.stopUpdatingLocation()
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getLocationDetails()
            requestWeatherForLocation()
        }
    }
    
    // MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        
        cell.configure(with: self.items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func requestWeatherForLocation() -> Void {
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&current_weather=true&daily=weathercode,temperature_2m_max,temperature_2m_min&timezone=IST"
        
        downloadWeatherFor(url)
        
    }

    func downloadWeatherFor(_ url: String) {
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: url)!) { data, response, error in
            
            guard let data = data, error == nil else {
                print("Could not fetch weather data ☹️")
                return
            }
            
            if let weatherData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                
                let current = weatherData["current_weather"] as! [String: Any]
                
                let currentWeather = Weather(date: current["time"] as! String, minTemperature: "", maxTemperature: "\(current["temperature"]!) ºC", weatherCode: current["weathercode"] as! Int)
                
                let dailyUnits = weatherData["daily_units"] as! [String: String]
                
                let daily = weatherData["daily"] as! [String: [Any]]
                
                let dates = daily["time"] as! [String]
                let minTemperatures = daily["temperature_2m_min"] as! [Double]
                let maxTemperatures = daily["temperature_2m_max"] as! [Double]
                let weatherCodes = daily["weathercode"] as! [Int]
                
                self.items.removeAll()
                
                for i in 0..<dates.count {
                    let date = dates[i]
                    
                    self.items.append(Weather(date: date, minTemperature: "\(minTemperatures[i]) \(dailyUnits["temperature_2m_min"]!)", maxTemperature: "\(maxTemperatures[i]) \(dailyUnits["temperature_2m_max"]!)", weatherCode: weatherCodes[i]))
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    self.tableView.tableHeaderView = self.createTableHeaderView(currentWeather)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func createTableHeaderView(_ currentWeather: Weather) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        
        view.backgroundColor = WeatherUtils.backgroundColor1
        
        let locationLabel = UILabel(frame: CGRect(x: 0, y: 10, width: view.frame.size.width-20, height: view.frame.size.height/5))
        
        let summaryLabel = UILabel(frame: CGRect(x: 0, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: view.frame.size.height/5))
        
        let tempLabel = UILabel(frame: CGRect(x: 0, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: view.frame.size.height/3))
        
        view.addSubview(locationLabel)
        view.addSubview(tempLabel)
        view.addSubview(summaryLabel)
        
        locationLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        
        locationLabel.text = self.currentLocationDetails
        summaryLabel.text = WeatherUtils.fetchWeatherSummary(for: currentWeather.weatherCode)
        tempLabel.text = currentWeather.maxTemperature
        
        locationLabel.textColor = .white
        tempLabel.textColor = .white
        summaryLabel.textColor = .white
        
        return view
    }
    
    func getLocationDetails() -> String? {
        
        guard let location = currentLocation else {
            return nil
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error == nil {
                let subLocality = placeMarks?.first?.subLocality
                let locality = placeMarks?.first?.locality
                let country = placeMarks?.first?.country
                
                self.currentLocationDetails = subLocality
                
                if self.currentLocationDetails == nil {
                    self.currentLocationDetails = ""
                    self.currentLocationDetails!.append("\(locality!), \(country!)")
                } else {
                    self.currentLocationDetails!.append(", \(locality!), \(country!)")
                }                
            }
        }
        
        return nil
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct Weather {
    var date: String
    var minTemperature: String
    var maxTemperature: String
    var weatherCode: Int
}
