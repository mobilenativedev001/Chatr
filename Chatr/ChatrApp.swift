//
//  ChatrApp.swift
//  Chatr
//
//  Created by Yogeswaran Sivagurun - EXT on 2026-05-20.
//

import SwiftUI

@main
struct ChatrApp: App {
    // show a runtime splash screen for a brief period before showing the main ContentView
    @State private var showingSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showingSplash {
                    SplashView()
                } else {
                    LoginView()
                }
            }
            .onAppear {
                // keep the splash visible for 1.6 seconds (adjust as needed)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    withAnimation(.easeOut(duration: 0.35)) {
                        showingSplash = false
                    }
                }
            }
        }
    }
}
