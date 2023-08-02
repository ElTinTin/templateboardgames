//
//  ConfigManager.swift
//  templateboardgames
//
//  Created by Quentin Deschamps on 19/07/2023.
//

import Foundation
import SwiftUI


// Add your configFileName here
#if template
    let configFileName = "template"
#elseif whitelabel
    let configFileName = "whitelabel"
#endif

class ConfigManager: ObservableObject {
    let appName: String
    let primaryColorLight: Color
    let primaryColorMedium: Color
    let favoriteFeature: Bool
    
    init() {
        // Load correct config file
        guard let configFileURL = Bundle.main.url(forResource: configFileName, withExtension: "plist"),
              let configData = try? Data(contentsOf: configFileURL),
              let config = try? PropertyListSerialization.propertyList(from: configData, options: [], format: nil) as? [String: Any] else {
            fatalError("Impossible de charger le fichier de configuration")
        }
        
        // Access to config values
        self.appName = config["appName"] as? String ?? ""
        self.primaryColorLight = Color.init(hex: config["primaryColor"] as? String ?? "").opacity(0.2)
        self.primaryColorMedium = Color.init(hex: config["primaryColor"] as? String ?? "").opacity(0.5)
        self.favoriteFeature = config["favoriteFeature"] as? Bool ?? false
    }
}
