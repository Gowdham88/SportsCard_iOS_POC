//
//  ViewController.swift
//  newPangestureforSportsApp
//
//  Created by Superpower on 01/07/20.
//  Copyright © 2020 iMac superpower. All rights reserved.
//

import UIKit
import ImageScrollView
import Vision
import VisionKit

//import AKImageCropperView

var PanView : String = "one"
var CroppedImage: UIImage!

var borderview1XY : BorderView = BorderView(id: 1, x: 1.0, y: 1.0, scale: 1.03)
var borderview2XY : BorderView = BorderView(id: 1, x: 1.0, y: 1.0, scale: 1.03)
var borderview3XY : BorderView = BorderView(id: 1, x: 1.0, y: 1.0, scale: 1.03)
var borderview4XY : BorderView = BorderView(id: 1, x: 1.0, y: 1.0, scale: 1.03)

class ViewController: UIViewController, ImageScrollViewDelegate, UIScrollViewDelegate, VNDocumentCameraViewControllerDelegate {
    

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ImageScrollView: ImageScrollView!
    @IBOutlet weak var borderview1: UIView!
    @IBOutlet weak var borderview2: UIView!
    @IBOutlet weak var borderview3: UIView!
    @IBOutlet weak var borderview4: UIView!
    
    @IBOutlet weak var leftPixelsPercent: UILabel!
    @IBOutlet weak var rightPixelsPercent: UILabel!
    @IBOutlet weak var topPixelsPercent: UILabel!
    @IBOutlet weak var bottonPixelsPercent: UILabel!
    
    var NewCropImage = UIImage()
    
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
       private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
   
    
    let defaults =  UserDefaults.standard
    
    var scaledX : CGFloat!
    var scaledY : CGFloat!
    
    var border1Scale: CGFloat!
    var border2Scale: CGFloat!
    var border3Scale: CGFloat!
    var border4Scale: CGFloat!
    
    let baseWidth = 403.59599999999995
    let baseHeight = 583.330752
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        setupVision()
        
        print("View did load")
        
        contentView.alpha = 1
        borderview1.alpha = 1
        borderview2.alpha = 1
        borderview3.alpha = 1
        borderview4.alpha = 1
        
        ImageScrollView.setup()
        //ImageScrollView.display(image: myImage!)
        ImageScrollView.imageScrollViewDelegate = self
        ImageScrollView.imageContentMode = .aspectFit
        
        
//        borderview1.frame = CGRect(x: 50, y: 0, width: 15, height: ImageScrollView.contentSize.height)
//        borderview3.frame = CGRect(x: ImageScrollView.contentSize.width - 10, y: ImageScrollView.contentSize.height - 20, width: 15, height: ImageScrollView.contentSize.height)
//
//        borderview2.frame = CGRect(x: 0, y: 50, width: ImageScrollView.contentSize.width, height: 15)
//        borderview4.frame = CGRect(x: 0, y: ImageScrollView.contentSize.height - 10, width: ImageScrollView.contentSize.width, height: 15)
        
        ImageScrollView.addSubview(borderview1)
        ImageScrollView.addSubview(borderview2)
        ImageScrollView.addSubview(borderview3)
        ImageScrollView.addSubview(borderview4)
//        ImageScrollView.addSubview(borderview2)
//        ImageScrollView.addSubview(borderview3)
//        ImageScrollView.addSubview(borderview4)
        ImageScrollView.autoresizesSubviews = true
        borderview1.autoresizesSubviews = true
        borderview2.autoresizesSubviews = true
        borderview3.autoresizesSubviews = true
        borderview4.autoresizesSubviews = true
        
        
        SaveoriginalImagesize()
        
    }
    

    func SaveoriginalImagesize() {
        
        let frame1 = borderview1.convert(borderview1.frame, to: nil)
        let frame2 = borderview2.convert(borderview2.frame, to: nil)
        let frame3 = borderview3.convert(borderview3.frame, to: nil)
        let frame4 = borderview4.convert(borderview4.frame, to: nil)
        // convert(buttons.frame, from:secondView)
        
        borderview1XY.id = 1
        borderview1XY.x = frame1.origin.x
        borderview1XY.y = frame1.origin.y
        
        borderview2XY.id = 2
        borderview2XY.x = frame2.origin.x
        borderview2XY.y = frame2.origin.y
        
        borderview3XY.id = 3
        borderview3XY.x = frame3.origin.x
        borderview3XY.y = frame3.origin.y
        
        borderview4XY.id = 4
        borderview4XY.x = frame4.origin.x
        borderview4XY.y = frame4.origin.y

        border1Scale =  CGFloat(baseWidth) / borderview1XY.x
        border2Scale =  CGFloat(baseHeight) / borderview2XY.y
        border3Scale =  CGFloat(baseWidth) / borderview3XY.x
        border4Scale =  CGFloat(baseHeight) / borderview4XY.y
                          
        let bordercategory1 = BorderView(id: borderview1XY.id, x: borderview1XY.x, y: borderview1XY.y, scale: border1Scale)
        let bordercategory2 = BorderView(id: borderview2XY.id, x: borderview2XY.x, y: borderview2XY.y, scale: border2Scale)
        let bordercategory3 = BorderView(id: borderview3XY.id, x: borderview3XY.x, y: borderview3XY.y, scale: border3Scale)
        let bordercategory4 = BorderView(id: borderview4XY.id, x: borderview4XY.x, y: borderview4XY.y, scale: border4Scale)
        
        print("borderview4XY.y: \(borderview4XY.y)")
        print("border4Scale: \(border4Scale)")
     
        SaveUtil.saveBorder(borderview: bordercategory1)
        SaveUtil.saveBorder2(borderview: bordercategory2)
        SaveUtil.saveBorder3(borderview: bordercategory3)
        SaveUtil.saveBorder4(borderview: bordercategory4)
    }
    
    func calculateDistance() {
        
        borderview1XY = SaveUtil.loadBorder()
        borderview2XY = SaveUtil.loadBorder2()
        borderview3XY = SaveUtil.loadBorder3()
        borderview4XY = SaveUtil.loadBorder4()
        
        let leftPixelsBorder1 = borderview1XY.x
        let RightPixelsXBorder3 = ImageScrollView.contentSize.width - borderview3XY.x
        let TopPixelsBorder2 = borderview2XY.y
        let BottomPixelsBorder4 = ImageScrollView.contentSize.height - borderview4XY.y
        
        print("leftPixelsBorder1: \(borderview1XY.x)")
        print("TopPixelsBorder2: \(borderview2XY.y)")
        
        let pixelsbetween1and3 = ImageScrollView.contentSize.width - (leftPixelsBorder1! + RightPixelsXBorder3)
        
        let pixelsbetween2and4 = ImageScrollView.contentSize.height - (TopPixelsBorder2! + BottomPixelsBorder4)
    
        let visualcenterleft = pixelsbetween1and3/2 + leftPixelsBorder1!
        
        let visualcenterright = pixelsbetween1and3/2 + RightPixelsXBorder3
        
        let visualcentertop = pixelsbetween2and4/2 + TopPixelsBorder2!
        
        let visualcenterbottom = pixelsbetween2and4/2 + BottomPixelsBorder4
        
        let left = visualcenterleft / (ImageScrollView.contentSize.width/2)
        let right = visualcenterright / (ImageScrollView.contentSize.width/2)
        let top = visualcentertop / (ImageScrollView.contentSize.height/2)
        let bottom = visualcenterbottom / (ImageScrollView.contentSize.height/2)
        
        print("ImageScrollView.contentSize.width: \(ImageScrollView.contentSize.width)")
        print("ImageScrollView.contentSize.height: \(ImageScrollView.contentSize.height)")
        print("myImage?.cgImage?.width: \(NewCropImage.size.width)")
        print("myImage?.cgImage?.height: \(NewCropImage.size.height)")
        
        
        print("left: \(left)")
        print("Right: \(right)")
        print("Top: \(top)")
        print("Bottom: \(bottom)")
        
        leftPixelsPercent.text = "\(left)"
        rightPixelsPercent.text = "\(right)"
        topPixelsPercent.text = "\(top)"
        bottonPixelsPercent.text = "\(bottom)"
        
        print("pixelsbetween1and3: \(pixelsbetween1and3)")
        print("pixelsbetween2and4: \(pixelsbetween2and4)")
        print("borderview1XY.x: \(borderview1XY.x)")
        print("borderview2XY.y: \(borderview2XY.y)")
        
//        CroppedImage = cropToBounds(image: myImage!, width: Double(pixelsbetween1and3), height: Double(pixelsbetween2and4), posX1: borderview1XY.x, posY1: borderview2XY.y)
        
        var X_Crop_Scale = leftPixelsBorder1!/ImageScrollView.contentSize.width

        var Y_Crop_Scale = TopPixelsBorder2!/ImageScrollView.contentSize.height

        var X_scaled_Crop = X_Crop_Scale * (NewCropImage.size.width)
        var Y_scaled_Crop = Y_Crop_Scale * (NewCropImage.size.height)

        var TwoImageWidthScale = ImageScrollView.contentSize.width / (NewCropImage.size.width)
        var TwoImageHeightScale = ImageScrollView.contentSize.height / (NewCropImage.size.height)

        var New_Pixels1and3 = pixelsbetween1and3 / TwoImageWidthScale
        var New_Pixels2and4 =  pixelsbetween2and4 / TwoImageHeightScale

        print("leftPixelsBorder1: \(leftPixelsBorder1)")
        print("TopPixelsBorder2: \(TopPixelsBorder2)")

        print("X_Crop_Scale: \(X_Crop_Scale)")
        print("Y_Crop_Scale: \(Y_Crop_Scale)")

        print("X_scaled_Crop: \(X_scaled_Crop)")
        print("Y_scaled_Crop: \(Y_scaled_Crop)")
        print("New_Pixels1and3: \(New_Pixels1and3)")
        print("New_Pixels1and3: \(New_Pixels2and4)")
        
        
        let size = CGSize(width: New_Pixels1and3, height:New_Pixels2and4)
        CroppedImage = NewCropImage.crop(to: size, newx: X_scaled_Crop, newy: Y_scaled_Crop)
         
//        print("myImage?.size.width: \(myImage?.size.width)")
//        print("myImage?.size.height: \(myImage?.size.height)")
//        print("CroppedImage.size.width: \(CroppedImage.size.width)")
//        print("CroppedImage.size.height: \(CroppedImage.size.height)")
     
    }
    
    @IBAction func btnTakePicture(_ sender: Any) {
           
           let scannerViewController = VNDocumentCameraViewController()
           scannerViewController.delegate = self
           present(scannerViewController, animated: true)
       }
       
       private func setupVision() {
           textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
               guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
               
               var detectedText = ""
               for observation in observations {
                   guard let topCandidate = observation.topCandidates(1).first else { return }
                   print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
       
                   detectedText += topCandidate.string
                   detectedText += "\n"
               }
               
               DispatchQueue.main.async {
//                   self.textView.text = detectedText
//                   self.textView.flashScrollIndicators()

               }
           }

           textRecognitionRequest.recognitionLevel = .accurate
       }
       
       private func processImage(_ image: UIImage) {

//        imageView.image = image
        
        ImageScrollView.display(image: image)
        
        
        ImageScrollView.imageScrollViewDelegate = self
                
                ImageScrollView.addSubview(borderview1)
                ImageScrollView.addSubview(borderview2)
                ImageScrollView.addSubview(borderview3)
                ImageScrollView.addSubview(borderview4)
        //        ImageScrollView.addSubview(borderview2)
        //        ImageScrollView.addSubview(borderview3)
        //        ImageScrollView.addSubview(borderview4)
                ImageScrollView.autoresizesSubviews = true

           recognizeTextInImage(image)
       }
       
       private func recognizeTextInImage(_ image: UIImage) {
           guard let cgImage = image.cgImage else { return }
           
          // textView.text = ""
           textRecognitionWorkQueue.async {
               let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
               do {
                   try requestHandler.perform([self.textRecognitionRequest])
               } catch {
                   print(error)
               }
           }
       }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
           guard scan.pageCount >= 1 else {
               controller.dismiss(animated: true)
               return
           }
           
           let originalImage = scan.imageOfPage(at: 0)
           let newImage = compressedImage(originalImage)
           controller.dismiss(animated: true)
            
        NewCropImage = newImage

           processImage(newImage)
       }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
           print(error)
           controller.dismiss(animated: true)
       }
       
       func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
           controller.dismiss(animated: true)
       }

       func compressedImage(_ originalImage: UIImage) -> UIImage {
           guard let imageData = originalImage.jpegData(compressionQuality: 1),
               let reloadedImage = UIImage(data: imageData) else {
                   return originalImage
           }
           return reloadedImage
       }

    @IBAction func handlePan1(_ gesture: UIPanGestureRecognizer) {
        
        print("Pan1 Called")
        
        PanView = "Border1"
        
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }
        
      gestureView.center = CGPoint (
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y )
        
        let frame = borderview1.convert(borderview1.frame, to: nil) // convert(buttons.frame, from:secondView)

        print("gestureView.frame.origin.x: \(gestureView.frame.origin.x)")
        
        if gestureView.frame.origin.x > ImageScrollView.contentSize.width / 2 - 10 {
            
            gestureView.frame = CGRect(x: ImageScrollView.contentSize.width/2 - 10, y: 0, width: 15, height: ImageScrollView.contentSize.height)
            
                        borderview1XY.id = 1
                        borderview1XY.x = ImageScrollView.contentSize.width / 2 - 10
                        borderview1XY.y = frame.origin.y
                        //border1Scale =  CGFloat(baseWidth) / borderview1XY.x
            border1Scale =  ImageScrollView.contentSize.width / borderview1XY.x
            
                        let bordercategory = BorderView(id: borderview1XY.id, x: borderview1XY.x, y: borderview1XY.y, scale: border1Scale)
         
                        SaveUtil.saveBorder(borderview: bordercategory)
                        
        } else if gestureView.frame.origin.x < 10 {
            
            gestureView.frame = CGRect(x: 10, y: 0, width: 15, height: ImageScrollView.contentSize.height)
            
                            borderview1XY.id = 1
                           borderview1XY.x = 10
                           borderview1XY.y = frame.origin.y
                           border1Scale = ImageScrollView.contentSize.width / borderview1XY.x
                           let bordercategory = BorderView(id: borderview1XY.id, x: borderview1XY.x, y: borderview1XY.y, scale: border1Scale)
            
                           SaveUtil.saveBorder(borderview: bordercategory)
            
        } else {
            
                        borderview1XY.id = 1
                        borderview1XY.x = gestureView.frame.origin.x
                        borderview1XY.y = frame.origin.y
                        border1Scale =  ImageScrollView.contentSize.width / borderview1XY.x
                        
                        let bordercategory = BorderView(id: borderview1XY.id, x: borderview1XY.x, y: borderview1XY.y, scale: border1Scale)
                        SaveUtil.saveBorder(borderview: bordercategory)
            //            borderview1.frame = CGRect(x: borderview1XY.x, y: 0, width: 15, height: ImageScrollView.contentSize.height)
        }
        
        gesture.minimumNumberOfTouches =  1
        gesture.maximumNumberOfTouches = 1
        
                
      gesture.setTranslation(.zero, in: view)
        
    calculateDistance()
       
        
//        print("2.handlePan1 borderview1XY.x: \(borderview1XY.x)")
//        print("2.handlePan1 borderview1XY.y: \(borderview1XY.y)")
//        print("2.handlePan1 border1Scale: \(border1Scale)")
//        print("2.handlePan1 Border saved")
        
    }
    
    @IBAction func handlePan2(_ gesture: UIPanGestureRecognizer) {
        
        print("Pan2 Called")
        PanView = "Border2"
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

        gestureView.center = CGPoint(
           x: gestureView.center.x,
           y: gestureView.center.y + translation.y
         )
                
        
        //=============================================
              
              let frame = borderview2.convert(borderview2.frame, to: nil) // convert(buttons.frame, from:secondView)

                    print("gestureView.frame.origin.y: \(gestureView.frame.origin.y)")
              
                    if gestureView.frame.origin.y > ImageScrollView.contentSize.height / 2 - 10 {
                        
                    gestureView.frame = CGRect(x: 0, y: ImageScrollView.contentSize.height / 2 - 10, width: ImageScrollView.contentSize.width, height: 15)
                        
                      borderview2XY.id = 2
                      borderview2XY.x = frame.origin.x
                      borderview2XY.y = ImageScrollView.contentSize.height / 2 - 10
                      border2Scale =  ImageScrollView.contentSize.height / borderview2XY.y
                      
                      let bordercategory2 = BorderView(id: borderview2XY.id, x: borderview2XY.x, y: borderview2XY.y, scale: border2Scale)
                     
                      SaveUtil.saveBorder2(borderview: bordercategory2)
                                    
                    } else if gestureView.frame.origin.y < 10 {
                        
                    gestureView.frame = CGRect(x: 0, y: 10, width: ImageScrollView.contentSize.width, height: 15)
                      
                      borderview2XY.id = 2
                      borderview2XY.x = frame.origin.x
                      borderview2XY.y = 10
                      border2Scale =  ImageScrollView.contentSize.height / borderview2XY.y
                       let bordercategory2 = BorderView(id: borderview2XY.id, x: borderview2XY.x, y: borderview2XY.y, scale: border2Scale)
        
                       SaveUtil.saveBorder2(borderview: bordercategory2)
                        
                    } else {
                        
                        borderview2XY.id = 2
                        borderview2XY.x = frame.origin.x
                        borderview2XY.y = gestureView.frame.origin.y
                        border2Scale =  ImageScrollView.contentSize.height / borderview2XY.y
                        
                        let bordercategory2 = BorderView(id: borderview2XY.id, x: borderview2XY.x, y: borderview2XY.y, scale: border2Scale)
                        SaveUtil.saveBorder2(borderview: bordercategory2)
                      
                        //            borderview1.frame = CGRect(x: borderview1XY.x, y: 0, width: 15, height: ImageScrollView.contentSize.height)
                    }
                    
                    gesture.minimumNumberOfTouches =  1
                    gesture.maximumNumberOfTouches = 1
              
              //=============================================
        
        
      gesture.setTranslation(.zero, in: view)
        
        calculateDistance()
        
    }
    
    @IBAction func handlePan3(_ gesture: UIPanGestureRecognizer) {
      // 1
        
        print("Pan3 Called")
        PanView = "Border3"
        
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

      gestureView.center = CGPoint (
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y )
        
        //=============================================
        
        let frame = borderview3.convert(borderview3.frame, to: nil) // convert(buttons.frame, from:secondView)

              
              if gestureView.frame.origin.x > ImageScrollView.contentSize.width - 10 {
                  
                  gestureView.frame = CGRect(x: ImageScrollView.contentSize.width - 10, y: 0, width: 15, height: ImageScrollView.contentSize.height)
                  
                              borderview3XY.id = 3
                              borderview3XY.x = ImageScrollView.contentSize.width - 10
                              borderview3XY.y = frame.origin.y
                              border3Scale =  ImageScrollView.contentSize.width / borderview3XY.x
                              let bordercategory3 = BorderView(id: borderview3XY.id, x: borderview3XY.x, y: borderview3XY.y, scale: border3Scale)
               
                              SaveUtil.saveBorder3(borderview: bordercategory3)
                              
              } else if gestureView.frame.origin.x < ImageScrollView.contentSize.width / 2 + 10 {
                  
                  gestureView.frame = CGRect(x: ImageScrollView.contentSize.width / 2 + 10, y: 0, width: 15, height: ImageScrollView.contentSize.height)
                
                              borderview3XY.id = 3
                              borderview3XY.x = ImageScrollView.contentSize.width / 2 + 10
                              borderview3XY.y = frame.origin.y
                              border3Scale =  ImageScrollView.contentSize.width / borderview3XY.x
                              let bordercategory3 = BorderView(id: borderview3XY.id, x: borderview3XY.x, y: borderview3XY.y, scale: border3Scale)
               
                              SaveUtil.saveBorder3(borderview: bordercategory3)
                
                  
              } else {
                  
                              borderview3XY.id = 3
                              borderview3XY.x = gestureView.frame.origin.x
                              borderview3XY.y = frame.origin.y
                              border3Scale =  ImageScrollView.contentSize.width / borderview3XY.x
                              
                              let bordercategory3 = BorderView(id: borderview3XY.id, x: borderview3XY.x, y: borderview3XY.y, scale: border3Scale)
                              SaveUtil.saveBorder3(borderview: bordercategory3)
                  //            borderview1.frame = CGRect(x: borderview1XY.x, y: 0, width: 15, height: ImageScrollView.contentSize.height)
              }
              
              gesture.minimumNumberOfTouches = 1
              gesture.maximumNumberOfTouches = 1
        
        //=============================================
        
      gesture.setTranslation(.zero, in: view)
        
        calculateDistance()
        
    }
    
    @IBAction func handlePan4(_ gesture: UIPanGestureRecognizer) {
        
        print("Pan4 Called")
        PanView = "Border4"
      // 1
      let translation = gesture.translation(in: view)

      // 2
      guard let gestureView = gesture.view else {
        return
      }

        gestureView.center = CGPoint(
            x: gestureView.center.x,
            y: gestureView.center.y + translation.y
          )
        
        //=============================================
        
       let frame = borderview4.convert(borderview4.frame, to: nil)

              print("gestureView.frame.origin.y: \(gestureView.frame.origin.y)")
        
              if gestureView.frame.origin.y > ImageScrollView.contentSize.height - 20 {
                  
                  gestureView.frame = CGRect(x: 0, y: ImageScrollView.contentSize.height - 20, width: ImageScrollView.contentSize.width, height: 15)
                  
                borderview4XY.id = 4
                borderview4XY.x = frame.origin.x
                borderview4XY.y = ImageScrollView.contentSize.height - 20
                border4Scale =  ImageScrollView.contentSize.height / borderview4XY.y
                
                let bordercategory4 = BorderView(id: borderview4XY.id, x: borderview4XY.x, y: borderview4XY.y, scale: border4Scale)
               
                SaveUtil.saveBorder4(borderview: bordercategory4)
                              
              } else if gestureView.frame.origin.y < ImageScrollView.contentSize.height / 2 + 10 {
                  
                  gestureView.frame = CGRect(x: 0, y: ImageScrollView.contentSize.height / 2 + 10, width: ImageScrollView.contentSize.width, height: 15)
                
                    borderview4XY.id = 4
                    borderview4XY.x = frame.origin.x
                    borderview4XY.y = ImageScrollView.contentSize.height / 2 + 10
                    border4Scale =  ImageScrollView.contentSize.height / borderview4XY.y
                     let bordercategory4 = BorderView(id: borderview4XY.id, x: borderview4XY.x, y: borderview4XY.y, scale: border4Scale)
      
                     SaveUtil.saveBorder4(borderview: bordercategory4)
                  
              } else {
                  
                              borderview4XY.id = 4
                              borderview4XY.x = frame.origin.x
                              borderview4XY.y = gestureView.frame.origin.y
                              border4Scale =  ImageScrollView.contentSize.height / borderview4XY.y
                              
                              let bordercategory4 = BorderView(id: borderview4XY.id, x: borderview4XY.x, y: borderview4XY.y, scale: border4Scale)
                              SaveUtil.saveBorder4(borderview: bordercategory4)
                
                  //            borderview1.frame = CGRect(x: borderview1XY.x, y: 0, width: 15, height: ImageScrollView.contentSize.height)
              }
              
              gesture.minimumNumberOfTouches =  1
              gesture.maximumNumberOfTouches = 1
        
        //=============================================
                
      gesture.setTranslation(.zero, in: view)
        
        
        calculateDistance()
    }
    
    
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        
        print("imageScrollViewDidChangeOrientation")
        
    
    }
    
        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            
            print("Did end Zooming")
          
        
        }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
        print("View did Scroll called - Border loaded")
        
        //let frame = borderview1.convert(borderview1.frame, to: nil)
        
//        borderview1.autoresizesSubviews = true
        
        let borderviewRect1 = SaveUtil.loadBorder()
        let borderviewRect2 = SaveUtil.loadBorder2()
        let borderviewRect3 = SaveUtil.loadBorder3()
        let borderviewRect4 = SaveUtil.loadBorder4()
        
        var borderX = borderviewRect1.x!
        var scaleWidth1 = borderviewRect1.scale
        let imagecontentSizewidth = ImageScrollView.contentSize.width
        let imagecontentSizeheight = ImageScrollView.contentSize.height
        var ImageScrollViewwidth = ImageScrollView.bounds.width
        var ImageScrollViewheight = ImageScrollView.bounds.height
        

        var scaleFactorX = imagecontentSizewidth / scaleWidth1!
        
        var ImageScrollViewcontentOffset = ImageScrollView.contentOffset
        var ImageScrollViewcontentinset  = ImageScrollView.contentInset
        var scrollviewwidth = scrollView.frame.width
        var scrollviewheight = scrollView.frame.height
        var scrollviewboundswidth = scrollView.bounds.size.width
        var scrollviewboundsheight = scrollView.bounds.size.height
        
        let frame1 = borderview1.convert(borderview1.frame, to: nil) // convert(buttons.frame, from:secondView)
               
//
//        print("borderviewRect.x / borderX: \(borderviewRect1.x)")
//        print("borderviewRect.scale / scaleWidth: \(borderviewRect1.scale)")
//       // print("scrollView.zoomScale: \(scrollView.zoomScale)")
//        print("ImageScrollView.contentSize.width / imagewidth: \(ImageScrollView.contentSize.width)")
//        print("ImageScrollView.contentSize.height / imageheight: \(ImageScrollView.contentSize.height)")
//        print("ImageScrollView.bounds.width / ImageScrollViewwidth: \(ImageScrollView.bounds.width)")
//        print("scaleFactorX, imagecontentSizewidth / scaleWidth: \(imagecontentSizewidth / scaleWidth1!)")
//        print("ImageScrollViewcontentOffset: \(ImageScrollViewcontentOffset)")
//        print("ImageScrollViewcontentinset: \(ImageScrollViewcontentinset)")
//        print("scrollviewwidth: \(scrollviewwidth)")
//        print("scrollviewheight: \(scrollviewheight)")
//        print("scrollviewboundswidth: \(scrollviewboundswidth)")
//        print("scrollviewboundsheight: \(scrollviewboundsheight)")
//        print("converted current borderview1.X: \(frame1.origin.x)")
//        print("converted current borderview1.Y: \(frame1.origin.y)")
//
        
//        
//        switch PanView {
//        case "Border1":
//            
//                                   
                  // BORDERVIEW1 ===================================================
                 
                 if scaleFactorX > imagecontentSizewidth / 2 - 20 {
                     
                     borderview1.frame = CGRect(x: imagecontentSizewidth / 2 - 20, y: 0, width: 15, height: imagecontentSizeheight)
                     
                     border1Scale =  (imagecontentSizewidth) / (imagecontentSizewidth * 0.5 - 20)
                     
                     let bordercategory = BorderView(id: borderview1XY.id, x: imagecontentSizewidth / 2 - 20, y: 0, scale: border1Scale)
                     
                     SaveUtil.saveBorder(borderview: bordercategory)
                     
                 } else if scaleFactorX < 20 {
                     
                     borderview1.frame = CGRect(x: 20, y: 0, width: 15, height: imagecontentSizeheight)
                                 
                     border1Scale =  imagecontentSizewidth / 20
                                 
                     let bordercategory = BorderView(id: borderview1XY.id, x: scaleFactorX, y: 0, scale: border1Scale)
                                 
                     SaveUtil.saveBorder(borderview: bordercategory)
                     
                 } else {
                     
                     borderview1.frame = CGRect(x: scaleFactorX, y: 0, width: 15, height: imagecontentSizeheight)
                     
                     border1Scale =  imagecontentSizewidth / scaleFactorX
                     
                     let bordercategory = BorderView(id: borderview1XY.id, x: scaleFactorX, y: 0, scale: border1Scale)
                     
                     SaveUtil.saveBorder(borderview: bordercategory)

                 }
            
//        case "Border2":
            
            // BORDERVIEW2 ===================================================
                   
                   var borderX2 = borderviewRect2.x!
                   var borderY2 = borderviewRect2.y!
                   var scaleHeight2 = borderviewRect2.scale
                   var scaleFactorY2 = imagecontentSizeheight / scaleHeight2!
                   let frame2 = borderview2.convert(borderview2.frame, to: nil)
        
                    
                   if scaleFactorY2 > imagecontentSizeheight / 2 - 20 {
                       
                       borderview2.frame = CGRect(x: 0, y: imagecontentSizeheight / 2 - 20, width: imagecontentSizewidth, height: 15)
                       
                       border2Scale =  (imagecontentSizeheight) / (imagecontentSizeheight * 0.5 - 20)

                       let bordercategory2 = BorderView(id: borderview2XY.id, x: 0, y: (imagecontentSizeheight * 0.5) - 20, scale: border2Scale)
                       
                       SaveUtil.saveBorder2(borderview: bordercategory2)
                       
                   } else if scaleFactorY2 < 20 {
                       
                       borderview2.frame = CGRect(x: 0, y: 20, width: imagecontentSizewidth, height: 15)
                                   
                       border2Scale =  imagecontentSizeheight / 20
                                   
                       let bordercategory2 = BorderView(id: borderview2XY.id, x: 0, y: 20, scale: border2Scale)
                                   
                       SaveUtil.saveBorder2(borderview: bordercategory2)
                       
                   } else {
                       
                       borderview2.frame = CGRect(x: 0, y: scaleFactorY2, width: imagecontentSizewidth, height: 15)
                       
                       border2Scale =  imagecontentSizeheight / scaleFactorY2
                       
                       let bordercategory2 = BorderView(id: borderview2XY.id, x: 0, y: scaleFactorY2, scale: border2Scale)
                       
                       SaveUtil.saveBorder2(borderview: bordercategory2)

                   }
            
//        case "Border3":
            
              
            // BORDERVIEW3 ===================================================
                 var borderX3 = borderviewRect3.x!
                 var scaleWidth3 = borderviewRect3.scale
                 var scaleFactorX3 = imagecontentSizewidth / scaleWidth3!
                 let frame3 = borderview3.convert(borderview3.frame, to: nil)
                
                if scaleFactorX3 > imagecontentSizewidth - 50 {
                           
                           borderview3.frame = CGRect(x: imagecontentSizewidth - 50, y: 0, width: 15, height: ImageScrollView.contentSize.height)
                           
                           border3Scale =  (imagecontentSizewidth) / (imagecontentSizewidth - 50)
                           
                           let bordercategory3 = BorderView(id: borderview3XY.id, x: imagecontentSizewidth / 2 - 20, y: 0, scale: border3Scale)
                           
                           SaveUtil.saveBorder3(borderview: bordercategory3)
                           
                       } else if scaleFactorX3 < imagecontentSizewidth / 2 + 10 {
                           
                           borderview3.frame = CGRect(x: imagecontentSizewidth / 2 + 10, y: 0, width: 15, height: ImageScrollView.contentSize.height)
                                       
                           border3Scale =  imagecontentSizewidth / (imagecontentSizewidth / 2 + 10)
                                       
                           let bordercategory3 = BorderView(id: borderview3XY.id, x: imagecontentSizewidth / 2 + 10, y: 0, scale: border3Scale)
                                       
                           SaveUtil.saveBorder3(borderview: bordercategory3)
                           
                       } else {
                           
                           borderview3.frame = CGRect(x: scaleFactorX3, y: 0, width: 15, height: ImageScrollView.contentSize.height)
                           
                           border3Scale =  imagecontentSizewidth / scaleFactorX3
                           
                           let bordercategory3 = BorderView(id: borderview3XY.id, x: scaleFactorX3, y: 0, scale: border3Scale)
                           
                           SaveUtil.saveBorder3(borderview: bordercategory3)
            }

                
            
//        case "Border4":
            
                
                
            // BORDERVIEW4 ===================================================
                                      
                var borderX4 = borderviewRect4.x!
                var borderY4 = borderviewRect4.y!
                var scaleHeight4 = borderviewRect4.scale
                var scaleFactorY4 = imagecontentSizeheight / scaleHeight4!
        
        
                let frame4 = borderview4.convert(borderview4.frame, to: nil)
                       
                if scaleFactorY4 < imagecontentSizeheight / 2 + 10 {
                    
                    borderview4.frame = CGRect(x: 0, y: imagecontentSizeheight / 2 + 10, width: imagecontentSizewidth, height: 15)
                    
                    border4Scale =  (imagecontentSizeheight) / (imagecontentSizeheight * 0.5 + 10)

                    let bordercategory4 = BorderView(id: borderview4XY.id, x: 0, y: (imagecontentSizeheight * 0.5 + 10), scale: border4Scale)
                    
                    SaveUtil.saveBorder4(borderview: bordercategory4)
                    
                } else if scaleFactorY4 > imagecontentSizeheight - 50 {
                    
                    borderview4.frame = CGRect(x: 0, y: imagecontentSizeheight - 50, width: imagecontentSizewidth, height: 15)
                                
                    border4Scale =  imagecontentSizeheight / (imagecontentSizeheight - 50)
                                
                    let bordercategory4 = BorderView(id: borderview4XY.id, x: 0, y: imagecontentSizeheight - 50, scale: border4Scale)
                                
                    SaveUtil.saveBorder4(borderview: bordercategory4)
                    
                } else {
                    
                    borderview4.frame = CGRect(x: 0, y: scaleFactorY4, width: imagecontentSizewidth, height: 15)
                    
                    border4Scale =  imagecontentSizeheight / scaleFactorY4
                    
                    let bordercategory4 = BorderView(id: borderview4XY.id, x: 0, y: scaleFactorY4, scale: border4Scale)
                    
                    SaveUtil.saveBorder4(borderview: bordercategory4)

                }

        
    }
                  
               
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("scrollViewWillBeginZooming")
    }
    
    
   
    
    
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("Scroll view will begin dragging")
//    }
//
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//
//        print("Scroll View Did scroll to top")
//
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//    }
//
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDecelerating")
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
//    }

    

}

extension UIImage {

    func crop(to:CGSize, newx: CGFloat, newy: CGFloat) -> UIImage {

    guard let cgimage = self.cgImage else { return self }

    let contextImage: UIImage = UIImage(cgImage: cgimage)

    guard let newCgImage = contextImage.cgImage else { return self }

    let contextSize: CGSize = contextImage.size

    //Set to square
    var posX: CGFloat = newx
    var posY: CGFloat = newy
    let cropAspect: CGFloat = to.width / to.height

    var cropWidth: CGFloat = to.width
    var cropHeight: CGFloat = to.height

//    if to.width > to.height { //Landscape
//        cropWidth = contextSize.width
//        cropHeight = contextSize.width / cropAspect
//        posY = (contextSize.height - cropHeight) / 2
//    } else if to.width < to.height { //Portrait
//        cropHeight = contextSize.height
//        cropWidth = contextSize.height * cropAspect
//        posX = (contextSize.width - cropWidth) / 2
//    } else { //Square
//        if contextSize.width >= contextSize.height { //Square on landscape (or square)
//            cropHeight = contextSize.height
//            cropWidth = contextSize.height * cropAspect
//            posX = (contextSize.width - cropWidth) / 2
//        }else{ //Square on portrait
//            cropWidth = contextSize.width
//            cropHeight = contextSize.width / cropAspect
//            posY = (contextSize.height - cropHeight) / 2
//        }
//    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

    // Create bitmap image from context using the rect
    guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

    // Create a new image based on the imageRef and rotate back to the original orientation
    let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

    UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
    cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
    let resized = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resized ?? self
  }
}
