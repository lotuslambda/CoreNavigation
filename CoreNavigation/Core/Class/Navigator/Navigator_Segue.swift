extension Navigator {
    func performSegue(
        with segueIdentifier: String,
        operation: Navigation.Operation
        ) {
        let sourceViewController = configuration.sourceViewController
        sourceViewController.coreNavigationEvents = UIViewController.Observer()

        sourceViewController.coreNavigationEvents?.onPrepareForSegue({ [weak self] (segue, sender) in
            self?.configuration.prepareForSegueBlock?(segue, sender)
            self?.passData(self?.configuration.dataPassingBlock, to: [segue.destination])
            self?.configuration.viewControllerEventBlocks.forEach({ (block) in
                self?.bindEvents(to: segue.destination as! DestinationType.ViewControllerType, navigationEvents: block())
            })
            if self?.configuration.dataPassingBlock == nil {
                self?.prepareForStateRestorationIfNeeded(viewController: segue.destination, viewControllerData: nil)
            }
        })
        
        func action() {
            sourceViewController.performSegue(withIdentifier: segueIdentifier, sender: sourceViewController)
            
            sourceViewController.coreNavigationEvents = nil
        }
        
        if let delayBlock = self.configuration.delayBlock {
            let timeInterval = delayBlock()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
        } else {
            DispatchQueue.main.async(execute: action)
        }
    }
}
