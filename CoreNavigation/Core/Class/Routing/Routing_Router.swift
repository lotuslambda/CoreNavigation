extension Routing {
    class Router {
        static let instance = Router()
        
        private var registrations: [String: Registration] = [:]
        
        func register<T: Routable>(routableType: T.Type) {
            registrations[routableType.identifier()] = Registration(destinationType: routableType, patterns: routableType.routePatterns())
        }
        
        func register(destinationType: AnyDestination.Type, patterns: [String]) {
            registrations[destinationType.identifier()] =  Registration(destinationType: destinationType, patterns: patterns)
        }
        
        func unregister(destinationType: AnyDestination.Type) {
            registrations[destinationType.identifier()] = nil
        }
        
        func unregister(pattern: String) {
            registrations = registrations.filter({ (registration) -> Bool in
                return !registration.value.patterns.contains(pattern)
            })
        }
        
        func match(for matchable: Matchable) -> Routing.RouteMatch? {
            var parameters: [String: Any]?
            
            guard let registration = (registrations.first { return $0.value.matches(matchable, &parameters) })?.value else {
                return nil
            }
            
            return Routing.RouteMatch(destinationType: registration.destinationType, parameters: parameters)
        }
    }
}

private extension AnyDestination {
    static func identifier() -> String {
        return String(describing: self)
    }
}

private extension Routing.Router {
    struct Registration {
        let destinationType: AnyDestination.Type
        let patterns: [String]
        
        func matches(_ matchable: Matchable, _ parameters: inout [String: Any]?) -> Bool {
            return self.patterns.first { (pattern) -> Bool in
                guard let regularExpression = try? Routing.RegularExpression(pattern: pattern) else {
                    return false
                }
                
                return regularExpression.matchResult(for: matchable.uri, parameters: &parameters)
                } != nil
        }
    }
}