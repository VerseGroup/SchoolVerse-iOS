//
//  Color.swift
//  SchoolVerse
//
//  Created by Daniel Shola-Philips on 8/25/22.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static let accent = AccentColors()
}

struct AccentColors {
    let blue = Color("Blue")
    let cyan = Color("Cyan")
    let pink = Color("Pink")
    let purple = Color("Purple")
}

// allows color to be put in UserDefaults
// source: https://stackoverflow.com/questions/73184367/swift-swiftui-saving-color-to-userdefaults-and-use-it-from-appstorage
extension Color: RawRepresentable {

    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        }catch{
            self = .black
        }
        
    }

    public var rawValue: String {
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        }catch{
            
            return ""
            
        }
        
    }

}
