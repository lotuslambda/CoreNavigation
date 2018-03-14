import Foundation

public protocol Eventable {
    associatedtype Events: EventAware
    associatedtype Event

    var events: Events { get set }
    
    @discardableResult func on(_ event: NavigationEvent) -> Self
    
    var event: Event { get }
}

extension Eventable {
    @discardableResult public func on(_ event: NavigationEvent) -> Self {
        events.navigationEvents.append(event)
        
        return self
    }
}