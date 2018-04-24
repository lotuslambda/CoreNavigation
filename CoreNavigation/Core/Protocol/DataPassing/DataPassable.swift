import Foundation

protocol DataPassable: class {
    associatedtype DataPassing: DataPassingAware
    
    var dataPassing: DataPassing { get set }
    
    @discardableResult func passData(_ data: Any?) -> Self
}

// MARK: - Abstract data passing configuration
extension Configuration: DataPassable {
    /// Prepares data for view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func passData(_ data: Any?) -> Self {
        queue.async(flags: .barrier) {
            self.dataPassing.data = data
        }
        
        return self
    }
}

// MARK: - Data receiving view controller data passing configuration
extension Configuration where ResultableType.ToViewController: DataReceivingViewController {
    /// Prepares data for data receiving view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func passData(_ data: ResultableType.ToViewController.DataType?) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        queue.async(flags: .barrier) {
            self.dataPassing.data = data
        }
        
        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }
}
