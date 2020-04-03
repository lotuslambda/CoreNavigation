import CoreNavigation
import SwiftUI

struct DestinationColor: Destination {
    typealias ViewType = ColorView
    @Binding var color: Color
    
    func resolveView(with resolver: Resolver<ColorView>) {
        resolver.complete(ColorView(color: $color))
    }
}
