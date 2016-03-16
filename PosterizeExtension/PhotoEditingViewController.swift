//
//  PhotoEditingViewController.swift
//  PosterizeExtension
//
//  Created by Nam (Nick) N. HUYNH on 3/16/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import OpenGLES

class PhotoEditingViewController: UIViewController, PHContentEditingController {

    @IBOutlet weak var imageView: UIImageView!
    
    var input: PHContentEditingInput?
    
    var output: PHContentEditingOutput!
    
    let filterName = "CIColorPosterize"
    
    let editFormatIdentifier = NSBundle.mainBundle().bundleIdentifier!
    
    let editFormatVersion = "1.0"
    
    let operationQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dataFromCIImage(image: CIImage) -> NSData {
        
        let glContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let context = CIContext(EAGLContext: glContext)
        let imageRef = context.createCGImage(image, fromRect: image.extent())
        let image = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Up)
        return UIImageJPEGRepresentation(image, 1.0)
        
    }
    
    func posterizedImageForInput(input: PHContentEditingInput) -> PHContentEditingOutput {
        
        let url = input.fullSizeImageURL
        let orientation = input.fullSizeImageOrientation
        
        let inputImage = CIImage(contentsOfURL: url, options: nil).imageByApplyingOrientation(orientation)
        
        let filter = CIFilter(name: filterName)
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage
        
        let editedImageData = dataFromCIImage(outputImage)
        let output = PHContentEditingOutput(contentEditingInput: input)
        editedImageData.writeToURL(output.renderedContentURL, atomically: true)
        output.adjustmentData = PHAdjustmentData(formatIdentifier: editFormatIdentifier, formatVersion: editFormatVersion, data: filterName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
        return output
        
    }
    
    func editingOperation() {
        
        output = posterizedImageForInput(input!)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let strongSelf = self
            let data = NSData(contentsOfURL: strongSelf.output.renderedContentURL, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            let image = UIImage(data: data!)
            strongSelf.imageView.image = image
            
        })
        
    }
    
    // MARK: - PHContentEditingController

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
        
        imageView.image = placeholderImage
        input = contentEditingInput
        let block = NSBlockOperation(block: editingOperation)
        operationQueue.addOperation(block)
        
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {

        completionHandler?(output)
        
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }

    func cancelContentEditing() {
        
        operationQueue.cancelAllOperations()
        
    }

}
