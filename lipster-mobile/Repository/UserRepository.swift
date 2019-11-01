import Foundation
import UIKit
import SwiftyJSON

class UserRepository {
    
    public static func authenticate(email: String, password: String, completion: @escaping (Int, [String]) -> Void) {
        let request = HttpRequest()
        request.post("api/login", ["email": email, "password": password], nil) { (response, httpStatusCode) -> (Void) in
            if httpStatusCode == 200 {
                let localStorage = UserDefaults.standard
                print(response!)
                let token = response!["token"].stringValue
                localStorage.set(token, forKey: "token")
                completion(200, ["success", "Welcome"])
            } else if httpStatusCode == 500 {
                completion(500, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            } else if httpStatusCode == 401 {
                completion(401, ["Login Failed", "Sorry, your email or password are wrong. Please try again."])
            }
            
        }
    }
    
    public static func register(email: String, password: String, firstname: String, lastname: String, gender: String, completion: @escaping (Bool, [String]) -> Void) {
        let request = HttpRequest()
        request.post(
            "api/register",
            [
                "email": email,
                "password": password,
                "firstname": firstname,
                "lastname": lastname,
                "gender": gender
            ],
            nil
        ) {response, httpStatusCode in
            if httpStatusCode == 200 {
                // MARK:Pass
                authenticate(email: email, password: password) { (status, messages) in
                    completion(true, messages)
                    return
                }
            } else if httpStatusCode == 400 {
                completion(false, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            } else if httpStatusCode == 0 {
                completion(false, ["No Internet Connection", "Make sure your device is connected to the internet"])
            } else {
                completion(false, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            }
        }
    }
    
    public static func setNotificationToken(token: String, completion: ((Bool) -> Void)?) {
        let request = HttpRequest()
        request.post("api/user/notification", ["notification_token": token], nil, requiredAuth: true) { (_, httpStatusCode) -> (Void) in
            if let closure = completion {
                if httpStatusCode == 200 {
                    // MARK: Pass
                    closure(true)
                } else {
                    closure(false)
                }
            }
            
        }
    }
}
