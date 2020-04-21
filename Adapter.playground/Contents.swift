import Foundation

// MARK: - Immutable

struct GoogleUser {
    var email: String
    var password: String
    var token: String
}

class GoogleAuthenticator {
    func login(email: String, password: String, completion: @escaping (GoogleUser?, Error?) -> Void) {
        // Make networking calls, which return a Token
        let token = "special-token-value"
        let user = GoogleUser(email: email, password: password, token: token)
        completion(user, nil)
    }
}

// MARK: - App Authentication Protocol

struct User {
    let email: String
    let password: String
}

struct Token {
    let value: String
}

protocol AuthenticationService {
    func login(email: String, password: String, success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void)
}

// MARK: - Adapter

class GoogleAuthenticatorAdapter: AuthenticationService {
    private var authenticator = GoogleAuthenticator()
    
    func login(email: String, password: String, success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void) {
        authenticator.login(email: email, password: password) { (googleUser, error) in
            guard let googleUser = googleUser else {
                failure(error)
                return
            }
            
            let user = User(email: googleUser.email, password: googleUser.password)
            let token = Token(value: googleUser.token)
            success(user, token)
        }
    }
}

// MARK: - Example

var authService: AuthenticationService = GoogleAuthenticatorAdapter()

authService.login(email: "user@example.com", password: "password", success: { (user, token) in
    print("Auth succeeded: \(user.email), \(token.value)")
}, failure: { (error) in
    if let error = error {
        print("Auth failed with error: \(error)")
    } else {
        print("Auth failed with error: no error provided")
    }
})
