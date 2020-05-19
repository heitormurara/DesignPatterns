import UIKit

/// Concrete Router
public class NavigationRouter: NSObject {
    
    private let navigationController: UINavigationController
    private let routerRootController: UIViewController?
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.routerRootController = navigationController.viewControllers.first
        super.init()
        navigationController.delegate = self
    }
}

// MARK: - Router
extension NavigationRouter: Router {
    
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        guard let routerRootController = routerRootController else {
            navigationController.popToRootViewController(animated: animated)
            return
        }
        
        performOnDismissed(for: routerRootController)
        navigationController.popToViewController(routerRootController, animated: animated)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else {
            return
        }
        
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

// MARK: - UINavigationControllerDelegate
extension NavigationRouter: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) else {
            return
        }
        
        performOnDismissed(for: dismissedViewController)
    }
}
