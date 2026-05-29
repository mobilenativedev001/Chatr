import SwiftUI

/// A simple runtime splash view. It will try to load an image named "LaunchImage"
/// from the app bundle or asset catalog. If the image isn't available it falls back
/// to a purple background with the app name centered so the app still looks presentable.
struct SplashView: View {
    var body: some View {
        ZStack {
            // Try to load an image named "LaunchImage" from assets / bundle
            if let uiImage = UIImage(named: "LaunchImage") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                // Fallback: purple background with centered branding text
                Color(red: 70/255, green: 16/255, blue: 115/255)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    Text("chatr")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    Text("MOBILE")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 242/255, green: 156/255, blue: 46/255))
                    Spacer()
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
