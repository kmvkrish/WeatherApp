//
//  WeatherUtils.swift
//  Weather
//
//  Created by Krishna Manoj Varanasi on 21/02/22.
//

import Foundation
import UIKit

class WeatherUtils {
    
    static let backgroundColor1 = UIColor(red: 52/255, green: 109/255, blue: 179/255, alpha: 1)
    
    static func fetchIconFor(weatherCode: Int) -> UIImage? {
        if weatherCode == 0 || weatherCode == 1 {
            return UIImage(named: "clear")
        } else if [2, 3].contains(weatherCode) {
            return UIImage(named: "cloud")
        } else  if [51, 52, 53, 54, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82, 85, 86, 95, 96, 99].contains(weatherCode) {
            return UIImage(named: "rain")
        }
        
        return nil
    }
    
    static func fetchWeatherSummary(for weatherCode: Int) -> String {
        
        if [1, 2, 3].contains(weatherCode) {
            
            return "Mainly clear, partly cloudy, and overcast"
            
        } else if [45, 48].contains(weatherCode) {
            
            return "Fog and depositing rime fog"
            
        } else  if [51, 53, 55].contains(weatherCode) {
         
            return "Drizzle: Light, moderate, and dense intensity"
            
        } else if [56, 57].contains(weatherCode) {
            
            return "Freezing Drizzle: Light and dense intensity"
            
        } else if [61, 63, 65].contains(weatherCode) {
            
            return "Rain: Slight, moderate and heavy intensity"
            
        } else if [66, 67].contains(weatherCode) {
            
            return "Freezing Rain: Light and heavy intensity"
            
        } else if [71, 73, 75].contains(weatherCode) {
            
            return "Snow fall: Slight, moderate, and heavy intensity"
            
        } else if 77 == weatherCode {
            
            return "Snow grains"
            
        } else if [80, 81, 82].contains(weatherCode) {
            
            return "Rain showers: Slight, moderate, and violent"
            
        } else if [85, 86].contains(weatherCode) {
            
            return "Snow showers slight and heavy"
            
        } else if [95, 96, 99].contains(weatherCode) {
            
            return "Thunderstorm with slight and heavy hail"
            
        }
        
        return "Clear Sky"
    }
    
}
