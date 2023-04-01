//
//  UserDefaultsManager.swift
//  D-Day
//
//  Created by hana on 2023/03/10.
//

import Foundation
import UIKit

class UserDefaultsManager{
    private final let currentDisplay = "currentDisplay"
    private final let currentSort = "currentSort"
    private final let alertData = "alertData"
    
    func setCurrentDisplay(index: Int){
        UserDefaults.standard.setValue(index, forKey: currentDisplay)
    }
    
    func setCurrentSort(index: Int){
        UserDefaults.standard.setValue(index, forKey: currentSort)
    }
    
    func getCurrentDisplay() -> Int{
        return UserDefaults.standard.integer(forKey: currentDisplay)
    }
    
    func getCurrentSort() -> Int{
        return UserDefaults.standard.integer(forKey: currentSort)
    }
    
    
    func setAlertTime(data: AlertData!){
        do{
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.setValue(encoded, forKey: alertData)
        }
        catch{
            print("UserData encode Error - \(error.localizedDescription)")
        }
    }

    func getAlertTime() -> AlertData{
        guard let savedData = UserDefaults.standard.object(forKey: alertData) as? Foundation.Data else {return AlertData()}

        do{
            return try JSONDecoder().decode(AlertData.self, from: savedData)
        }
        catch{
            print("UserData decode Error - \(error.localizedDescription)")
            return AlertData()
        }
    }
    
    func setIsDarkMode(isDarkMode: Bool!){
        UserDefaults.standard.setValue(isDarkMode, forKey: "isDarkMode")
    }

    func getIsDarkMode() -> Bool!{
        return UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
}
