//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Krishna Manoj Varanasi on 21/02/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with weather: Weather) {
        self.lowTemperatureLabel.text = weather.minTemperature
        self.highTemperatureLabel.text = weather.maxTemperature
        self.dayLabel.text = getDayForDate(date: weather.date)
        if let image = WeatherUtils.fetchIconFor(weatherCode: weather.weatherCode) {
            self.iconImageView.image = image
        }
        
        self.backgroundColor = WeatherUtils.backgroundColor1
    }
    
    func getDayForDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD"
        if let weatherDate = formatter.date(from: date) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: weatherDate)
        }
        
        return ""
        
    }

}
