//
//  UIApplication.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/4/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
