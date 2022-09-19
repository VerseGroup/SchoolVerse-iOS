//
//  FormValidationPopover.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/19/22.
//

import Foundation
import Popovers
import SwiftUI


public extension View {
    func warningAccessory(_ text: Binding<String>, valid: Binding<Bool>, warning: String, validation: @escaping (String) -> (Bool)) -> some View {
        modifier(WarningAccessoryModifier(text: text, valid: valid, warning: warning, validation: validation))
    }
}

func isNotEmpty(text: String) -> Bool {
    return !text.isEmpty
}

func isValidLength(text: String) -> Bool {
    return text.count >= 6
}

func isValidEmail(text: String) -> Bool {
    let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: text)
}

private struct WarningAccessoryModifier: ViewModifier {
    @Binding var text: String
    @Binding var valid: Bool
    let warning: String
    @State var present = false
    let validation: (String) -> (Bool)
    
    func body(content: Content) -> some View {
        HStack {
            content
                .popover(
                    present: $present,
                    attributes: {
                        $0.accessibility.shiftFocus = false
                        $0.sourceFrameInset.bottom = -26
                    }
                ) {
                    if let warning = warning {
                        Templates.Container {
                            Text(warning)
                                .font(.caption)
                        }
                    }
                }
            
            if !validation(text) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
        }
        .onChange(of: text) { _ in
            if !validation(text) {
                present = true
                valid = false
            } else {
                present = false
                valid = true
            }
        }
    }
}

