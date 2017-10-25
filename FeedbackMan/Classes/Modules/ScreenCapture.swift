import UIKit
import CoreGraphics
import ReplayKit

public final class ScreenCapture {
    
    private init() {
        // Intentionally unimplemented
    }
    
    class func takeScreenshot() -> UIImage? {
        let screenSize = UIScreen.main.bounds.size
        
        UIGraphicsBeginImageContextWithOptions(screenSize, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let application = UIApplication.shared
        application.keyWindow?.layer.render(in: context)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
}
