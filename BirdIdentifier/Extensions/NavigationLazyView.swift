//
//  NavigationLazyView.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 12/9/21.
//

import Foundation
import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
