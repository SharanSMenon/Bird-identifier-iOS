//
//  MLUtils.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/20/21.
//

import Foundation
import CoreML
import Vision
import UIKit

class ImagePredictor {
    static func createClassifier() -> VNCoreMLModel {
        let conf = MLModelConfiguration()
        let birdWrapper = try? BirdModel(configuration: conf)
        guard let birdClassifier = birdWrapper else {
            fatalError("App Failed to load Bird Identifier Mode")
        }
        let birdModel = birdClassifier.model
        
        guard let birdVNModel = try? VNCoreMLModel(for:birdModel) else {
            fatalError("App Created to Convert model to VNCoreMLModel")
        }
        return birdVNModel
    }
    
    private static let birdClassifier = createClassifier()
    
    struct Prediction {
        let classification: String
        let confidence: String
    }
    
    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.birdClassifier,
                                                         completionHandler: visionRequestHandler)
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)
        
        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }
        
        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler
        
        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        try handler.perform(requests)
    }
    
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }
        
        // Start with a `nil` value in case there's a problem.
        var predictions: [Prediction]? = nil
        
        // Call the client's completion handler after the method returns.
        defer {
            // Send the predictions back to the client.
            predictionHandler(predictions)
        }
        
        // Check for an error first.
        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }
        
        // Check that the results aren't `nil`.
        if request.results == nil {
            print("Vision request had no results.")
            return
        }
        
        // Cast the request's results as an `VNClassificationObservation` array.
        guard let observations = request.results as? [VNClassificationObservation] else {
            // Image classifiers, like MobileNet, only produce classification observations.
            // However, other Core ML model types can produce other observations.
            // For example, a style transfer model produces `VNPixelBufferObservation` instances.
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }
        
        // Create a prediction array from the observations.
        predictions = observations.map { observation in
            // Convert each observation into an `ImagePredictor.Prediction` instance.
            Prediction(classification: observation.identifier,
                       confidence: observation.confidencePercentageString)
        }
    }
}
