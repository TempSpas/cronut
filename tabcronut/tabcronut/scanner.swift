// import UIKit
// import Foundation

// extension UIImage {
//     /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
//     /// Switch MIN to MAX for aspect fill instead of fit.
//     ///
//     /// - parameter newSize: newSize the size of the bounds the image must fit within.
//     ///
//     /// - returns: a new scaled image.
//     func scaleImageToSize(newSize: CGSize) -> UIImage {
//         var scaledImageRect = CGRect.zero

//         let aspectWidth = newSize.width/size.width
//         let aspectheight = newSize.height/size.height

//         let aspectRatio = max(aspectWidth, aspectheight)

//         scaledImageRect.size.width = size.width * aspectRatio;
//         scaledImageRect.size.height = size.height * aspectRatio;
//         scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
//         scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;

//         UIGraphicsBeginImageContext(newSize)
//         draw(in: scaledImageRect)
//         let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//         UIGraphicsEndImageContext()

//         return scaledImage!
//     }
// }

// class Scanner 
// {
//     /* Code from the internet, URL: https://github.com/A9T9/code-snippets/blob/master/ocrapi.swift */
// 	let key = 4de28eea7e88957

//     func callOCRSpace(imageName: String) {
//         // Create URL request
//         var url: NSURL = NSURL(string: "https://api.ocr.space/Parse/Image")
//         var request: NSMutableURLRequest = NSMutableURLRequest.requestWithURL(url)
//         request.HTTPMethod = "POST"
//         var boundary: String = "randomString"
//         request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//         var session: NSURLSession = NSURLSession.sharedSession()

//         // Image file and parameters, get image down to 1MB file size
//         var compressionRatio = 1
//         var imageData: NSData

//         do {
//             imageData = UIImageJPEGRepresentation(UIImage.imageNamed(imageName), compressionRatio)
//             compressionRatio = compressionRatio - .05
//         } while(imageData.length >= 1024)

//         var parametersDictionary: [NSObject : AnyObject] = NSDictionary(objectsAndKeys: key,"apikey","False","isOverlayRequired","eng","language",nil)

//         // Create multipart form body
//         var data: NSData = self.createBodyWithBoundary(boundary, parameters: parametersDictionary, imageData: imageData, filename: imageName)
//         request.HTTPBody = data

//         // Start data session
//         var task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData, response: NSURLResponse, error: NSError) in 
//            var myError: NSError
//            var result: [NSObject : AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: kNilOptions, error: &myError)
//            // Handle result
//         })

//         task.resume()
//     }
   
//    func createBodyWithBoundary(boundary: String, parameters parameters: [NSObject : AnyObject], imageData data: NSData, filename filename: String) -> NSData {
       
//        var body: NSMutableData = NSMutableData.data()
       
//        if data {
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Type: image/jpeg\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            // body.appendData(data)
            // body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)) 

//        }
       
//        for key in parameters.allKeys {
//            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//            body.appendData("\(parameters[key])\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        }
       
//        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        return body
//    }

//    init() 
//    {

//    }
// }