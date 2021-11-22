//
//  BlueButton.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal)
    }
}
