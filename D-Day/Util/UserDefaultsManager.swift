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
      
    func getAlertTime() -> AlertTime!{
        guard let savedData = UserDefaults.standard.object(forKey: "alertTime") as? Foundation.Data else {return nil}

        do{
            return try JSONDecoder().decode(AlertTime.self, from: savedData)
        }
        catch{
            print("UserData decode Error - \(error.localizedDescription)")
            return nil
        }
    }
    
    func setAlertTime(data: AlertTime!){
        do{
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.setValue(encoded, forKey: "alertTime")
        }
        catch{
            print("UserData encode Error - \(error.localizedDescription)")
        }
    }
}
