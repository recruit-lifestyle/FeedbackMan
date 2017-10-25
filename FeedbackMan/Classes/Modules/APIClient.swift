import Foundation

final class APIClient{
    init() {
        // Intentionally unimplemented
    }
    
    static func get() {
        // Intentionally unimplemented
    }
    
    static func post(api:API, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: api.buildURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
      
        let parametersString: String = api.parameters.enumerated().reduce("") { (input, tuple) -> String in
            switch tuple.element.value {
            case let int as Int: return input + tuple.element.key + "=" + String(int) + (api.parameters.count - 1 > tuple.offset ? "&" : "")
            case let string as String: return input + tuple.element.key + "=" + string + (api.parameters.count - 1 > tuple.offset ? "&" : "")
            default: return input
            }
        }
        request.httpBody = parametersString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    static func multipartPost(api: API, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let url = URL(string: api.buildURL)
        let uniqueId = ProcessInfo.processInfo.globallyUniqueString
        let boundary = "---------------------------\(uniqueId)"
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: api.parameters,boundary: boundary)
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }

    static func createBody(parameters: [String: Any],
                    boundary: String) -> Data {
        var body = Data()
        for param in parameters {
            switch param.value {
            case let image as UIImage:
                var bodyText = String()
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                bodyText += "--\(boundary)\r\n"
                bodyText += "Content-Disposition: form-data; name=\"file\"; filename=\"\(param.key).jpg\"\r\n"
                bodyText += "Content-Type: image/jpeg\r\n\r\n"
                
                body.append(bodyText.data(using: String.Encoding.utf8)!)
                body.append(imageData!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            case let int as Int:
                var bodyText = String()
                bodyText += "--\(boundary)\r\n"
                bodyText += "Content-Disposition: form-data; name=\"\(param.key)\";\r\n"
                bodyText += "\r\n"
                
                body.append(bodyText.data(using: String.Encoding.utf8)!)
                body.append(String(int).data(using: String.Encoding.utf8)!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            case let string as String:
                var bodyText = String()
                bodyText += "--\(boundary)\r\n"
                bodyText += "Content-Disposition: form-data; name=\"\(param.key)\";\r\n"
                bodyText += "\r\n"

                body.append(bodyText.data(using: String.Encoding.utf8)!)
                body.append(string.data(using: String.Encoding.utf8)!)
                body.append("\r\n".data(using: String.Encoding.utf8)!)
            default:
                break
            }
        }
        var footerText = String()
        footerText += "\r\n"
        footerText += "\r\n--\(boundary)--\r\n"
        body.append(footerText.data(using: String.Encoding.utf8)!)
        return body as Data
    }    
}
