import Foundation
final class ModalPresenter {
    
    var uiScreenImage: UIImage?
    var fbdata = FeedbackData()
    
    init() {
        self.uiScreenImage = ScreenCapture.takeScreenshot()
    }
    
    func setFeedbackData() -> FeedbackData {
        fbdata.appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
        fbdata.deviceName = UIDevice.current.modelName
        fbdata.osVersion = UIDevice.current.systemVersion
        fbdata.appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        return fbdata
    }
    
    func postFeedbackData(_ fbdata: FeedbackData, completion: @escaping (Result<Bool, APIError>) -> Void) {
        let slackApi = SlackAPI.fileUpload(fbdata: fbdata)
        
        APIClient.multipartPost(api: slackApi, completion:
            { data, response, error in
                if let data = data, let response = response {
                    print(response)
                    self.jsonSerialize(data: data, completion: completion)
                } else {
                    print("Post Failed")
                    completion(.failure(.other))
                }
            }
        )
    }
    
    func jsonSerialize(data: Data, completion: @escaping (Result<Bool, APIError>) -> Void) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            
            let isPostSucceeded = json?["ok"] as? Bool ?? false
            if isPostSucceeded == true {
                print("Post Success")
                completion(.success(true))
            } else {
                print("Wrong Response")
                completion(.failure(.other))
            }
            
        } catch {
            print("Serialize Error")
            completion(.failure(.other))
        }
    }
}
