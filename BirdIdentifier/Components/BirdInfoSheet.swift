//
//  BirdInfoSheet.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import SwiftUI

struct BirdInfoSheet: View {
    @Binding var name: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Dismiss")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            BirdInfo(name: .constant(name))
        }
    }
}

struct BirdInfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        BirdInfoSheet(name: .constant("Haliaeetus leucocephalus"))
    }
}
