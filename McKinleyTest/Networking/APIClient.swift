
import UIKit
import Alamofire

enum APIError: Error{
    case reason(_ mesaage: String)
    
    func value() -> String {
         switch self {
         case .reason(let message):
             return message
         }
     }
}

class APIClient {
    
    func loginRequest(login:LoginRequestModel, completion: @escaping(Result<LoginResponseModel, APIError>) -> Void){

        let loginRequest = AF.request(Constants.BaseURL, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil)
    
        loginRequest.responseDecodable(of: LoginResponseModel.self, queue: .main, decoder: JSONDecoder()) { (response) in
            switch response.result{
            case .success(let values):
                    completion(.success(values))
            case .failure(let error):
                completion(.failure(.reason(error.errorDescription ?? "")))
            }
        }
        
     }
}
