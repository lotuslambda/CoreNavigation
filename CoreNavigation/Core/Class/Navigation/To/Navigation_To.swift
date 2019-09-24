extension Navigation {
    public class To {
        private let navigationType: Navigation.Direction
        private let queue: DispatchQueue

        init(navigationType: Navigation.Direction.Forward, queue: DispatchQueue) {
            self.navigationType = .forward(navigationType)
            self.queue = queue
        }

        @discardableResult public func to<DestinationType: Destination, FromType: UIViewController>(_ block: @escaping () -> DestinationType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<DestinationType, FromType> {
            Builder(configuration: Configuration<DestinationType, FromType>(directive: .direction(navigationType), toBlock: block, from: sourceViewController), queue: queue)
        }

        @discardableResult public func to<DestinationType: Destination, FromType: UIViewController>(_ destination: DestinationType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<DestinationType, FromType> {
            to({ destination }, from: sourceViewController)
        }

        @discardableResult public func to<FromType: UIViewController>(_ route: Matchable, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<Routing.Destination, FromType> {
            to(Routing.Destination(route: route), from: sourceViewController)
        }

        @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ viewController: ViewControllerType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<UIViewController.Destination<ViewControllerType>, FromType> {
            to(UIViewController.Destination(block: { viewController }), from: sourceViewController)
        }

        @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ viewControllerType: ViewControllerType.Type, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<UIViewController.Destination<ViewControllerType>, FromType> {
            to(UIViewController.Destination(block: { viewControllerType.init() }), from: sourceViewController)
        }

        @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ block: @escaping () -> ViewControllerType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<UIViewController.Destination<ViewControllerType>, FromType> {
            to(UIViewController.Destination(block: block), from: sourceViewController)
        }
    }

}
