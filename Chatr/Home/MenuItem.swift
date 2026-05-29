import Foundation

// MARK: - MenuItem

/// Represents each item in the HomeView side-drawer navigation menu.
enum MenuItem: String, Identifiable, CaseIterable {
    case plans    = "Plans"
    case devices  = "Devices"
    case internet = "Internet"
    case myOffers = "My Offers"
    case support  = "Support"
    case signOut  = "Sign Out"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .plans:    return "square.grid.2x2"
        case .devices:  return "iphone.gen1"
        case .internet: return "wifi"
        case .myOffers: return "tag"
        case .support:  return "questionmark.circle"
        case .signOut:  return "rectangle.portrait.and.arrow.right"
        }
    }
}
