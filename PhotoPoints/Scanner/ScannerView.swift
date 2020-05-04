//
//  ScannerView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/7/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // code modified from https://www.youtube.com/watch?v=4Zf9dHDJ2yU
    
    // variable that contains the video being shown to the user
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create video session
        // empty capture session for now
        let session = AVCaptureSession()
        
        // define capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { fatalError() }
        
        // now we want to take output from our camera device and put it in our session
        do {
            // taking result from capture device and storing in input constant
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
           print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        // process on main thread: best performance results
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // can also specify to look for faces or barcodes, but only selecting qr here
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // now we need to show the user
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    // terminate the session if we navigate off this view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    // bring the session up again if we switch back to the scanner view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    
    // called by system when we get metadataoutputs
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if  metadataObjects.count != 0 {
        
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                
                // get our list of possible URLS
                let plantURLs = MockDatabase.getURlStrings()
                
                // Potentially a url from QR code
                let objectString = object.stringValue ?? ""
                
                // see if the url is in the list of urls in our database
                if object.type == AVMetadataObject.ObjectType.qr && plantURLs.contains(objectString){
                
                    // plant is identified
                    let thisPlant = MockDatabase.getPlantFromURLString(urlString: objectString)
                    
                    // declare alert popups
                    let scannedAlert = UIAlertController(title: thisPlant.commonName, message: thisPlant.botanicalName, preferredStyle: .alert)
                    let surveyedAlert = UIAlertController(title: "Thank you!", message: "survey complete", preferredStyle: .alert)
                    
                    // add perform survey button and what to do if it's tapped
                    scannedAlert.addAction(UIAlertAction(title: "Perform Survey", style: .default, handler: { (nil) in
                        
                        // mock completion of survey, update value in MockDatabase
                        thisPlant.surveyStatus = .surveyed
                        
                        // update status based on commonName string as this is something we can search for in annotation array
                        mapVC.didUpdateSurveyStatus(commonName: thisPlant.commonName)
                        
                        // congradulate the user for surveying
                        self.present(surveyedAlert, animated: true, completion: nil)
                        
                    }))
                    
                    // add learn more button and what to do if it's tapped
                    scannedAlert.addAction(UIAlertAction(title: "Learn More", style: .default, handler:  { (nil) in
                        
                        // show plant detail page for this plant
                        self.present(PlantDetailView(plantItem: thisPlant), animated: true, completion: nil)
                        
                    }))
                    
                    // dismiss button that just gets rid of the alert
                    surveyedAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    // show scanned alert
                    present(scannedAlert, animated: true, completion: nil)
                }
            }
        }
    }
}
