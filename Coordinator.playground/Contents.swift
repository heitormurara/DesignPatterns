import PlaygroundSupport
import UIKit

let homeViewController = HomeViewController.instantiate()
let navigationController = UINavigationController(rootViewController: homeViewController)

let router = NavigationRouter(navigationController: navigationController)
let coordinator = HowToCodeCoordinator(router: router)

homeViewController.onButtonPressed = { [weak coordinator] in
coordinator?.present(animated: true, onDismissed: nil) }

PlaygroundPage.current.liveView = navigationController
