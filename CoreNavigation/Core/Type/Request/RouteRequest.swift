import SwiftUI
import Combine

public struct RouteRequest: Request {
    public var navigation: Navigation
    public var configuration: Configuration
    let uri: String
    
    var cancellable: AnyCancellable?
    
    public func push() {
        resolve()
    }
    
    public func sheet() {
        resolve()
    }
    
    private func resolve() {
        guard let match = Routing.Router.instance.match(for: uri) else { return }
        
        do {
            let route = Routing.Route(uri: uri, pattern: match.pattern, parameters: match.parameters)
            
            try match.destinationType.resolveDestination(route: route, destination: { (destination) in
                CoreNavigation.protect(destination: destination, continue: {
                    destination.resolveView(for: route, with: .init(route: route, onComplete: { (view) in
                        self.navigation.push(view: view, configuration: self.configuration)
                    }, onError: { (error) in
                        fatalError()
                    }))
                }, error: { error in
                    
                })
            }, failure: { (error) in
                fatalError()
            })
        } catch {
            
        }
    }
}
