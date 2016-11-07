import UIKit
import Foundation

class func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen

    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))

    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return scaledImage
}

//class Scanner 
//{
//    /* Code from the internet, URL: https://github.com/A9T9/code-snippets/blob/master/ocrapi.swift */
//	let key = 4de28eea7e88957
//
//    func callOCRSpace(imageName: String) {
//        // Create URL request
//        var url: NSURL = NSURL(string: "https://api.ocr.space/Parse/Image")
//        var request: NSMutableURLRequest = NSMutableURLRequest.requestWithURL(url)
//        request.HTTPMethod = "POST"
//        var boundary: String = "randomString"
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        var session: NSURLSession = NSURLSession.sharedSession()
//        
//        // Image file and parameters
//        var imageData: NSData = UIImageJPEGRepresentation(UIImage.imageNamed(imageName), 0.6)
//        var parametersDictionary: [NSObject : AnyObject] = NSDictionary(objectsAndKeys: key,"apikey","False","isOverlayRequired","eng","language",nil)
//        
//        // Create multipart form body
//        var data: NSData = self.createBodyWithBoundary(boundary, parameters: parametersDictionary, imageData: imageData, filename: imageName)
//        request.HTTPBody = data
//        
//        // Start data session
//        var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData, response: NSURLResponse, error: NSError) in 
//            var myError: NSError
//            var result: [NSObject : AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: kNilOptions, error: &myError)
//            // Handle result
//        })
//
//        task.resume()
//    }
//    
//    func createBodyWithBoundary(boundary: String, parameters parameters: [NSObject : AnyObject], imageData data: NSData, filename filename: String) -> NSData {
//        
//        var body: NSMutableData = NSMutableData.data()
//        
//        if data {
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData(data)
//            body.appendData(".dataUsingEncoding(NSUTF8StringEncoding))
//        }
//        
//        for key in parameters.allKeys {
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("\(parameters[key])\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        }
//        
//        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        return body
//    }
//
//    init() 
//    {
//
//    }
//}