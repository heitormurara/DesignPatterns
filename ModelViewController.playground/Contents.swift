import UIKit

// MARK: Model
public struct Address {
    
    public var street: String
    public var city: String
    public var state: String
    public var zipCode: String
}

// MARK: View
public final class AddressView: UIView {
    
    @IBOutlet public var streetTextField: UITextField!
    @IBOutlet public var cityTextField: UITextField!
    @IBOutlet public var stateTextField: UITextField!
    @IBOutlet public var zipCodeTextField: UITextField!
}

// MARK: Controller
public final class AddressViewController: UIViewController {
    
    public var address: Address? {
        didSet {
            updateViewFromAddress()
        }
    }
    
    public var addressView: AddressView! {
        guard isViewLoaded else { return nil }
        return (view as! AddressView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromAddress()
    }
    
    private func updateViewFromAddress() {
        guard let addressView = addressView,
              let address = address
        else { return }
        
        addressView.streetTextField.text = address.street
        addressView.cityTextField.text = address.city
        addressView.stateTextField.text = address.state
        addressView.zipCodeTextField.text = address.zipCode
    }
    
    @IBAction public func updateAddressFromView(_ sender: AnyObject) {
        guard let street = addressView.streetTextField.text,
              street.count > 0,
              let city = addressView.cityTextField.text,
              city.count > 0,
              let state = addressView.stateTextField.text,
              state.count > 0,
              let zipCode = addressView.zipCodeTextField.text,
              zipCode.count > 0
        else {
            return
        }
        
        address = Address(street: street,
                          city: city,
                          state: state,
                          zipCode: zipCode)
    }
}
