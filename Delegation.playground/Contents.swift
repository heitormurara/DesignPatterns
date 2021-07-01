import UIKit

public protocol MenuViewControllerDelegate: AnyObject {
    
    func menuViewController(_ menuViewController: MenuViewController,
                            didSelectItemAtIndex index: Int)
}

public class MenuViewController: UIViewController {
    
    public weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet public var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private let items = ["Item 1", "Item 2", "Item 3"]
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        delegate?.menuViewController(self,
                                     didSelectItemAtIndex: indexPath.row)
    }
}
