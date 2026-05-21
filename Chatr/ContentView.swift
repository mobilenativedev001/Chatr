//
//  ContentView.swift
//  Chatr
//
//  Created by Yogeswaran Sivagurun - EXT on 2026-05-20.
//

import SwiftUI
import Components

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("This is a sample application!")
      
            RDSButton(title: "Primary Button", action: {
                print("Primary Button tapped")
            }, variant: .primary)
            
            RDSButton(title: "Secoundary Button", action: {
                print("Secondary Button tapped")
            }, variant: .secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
