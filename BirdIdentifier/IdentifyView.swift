//
//  Identify.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import SwiftUI

struct Identify: View {
    @State private var showPhotoLibrary = false;
    @State private var showCamera = false;
    @State private var showInfoSheet = false;
    @State private var image = UIImage()
    @State private var classification: String = "";
    @State private var displayName: String = "";
    @ObservedObject var birdData = ReadData()
    let screenSize: CGRect = UIScreen.main.bounds
    
    let predictor = ImagePredictor()
    let predictionsToShow = 1
    
    var body: some View {
        VStack {
            if classification != "" {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight:screenSize.height-250)
                .overlay(alignment:.bottomLeading) {
                    if classification != "" {
                        IdentifyViewClassification(classification: self.classification, displayName: self.displayName, showInfoSheet: self.$showInfoSheet)
                    }
                }
                .overlay(alignment:.topLeading) {
                    if classification != "" && classification != "background" {
                        SaveObservationButton(observedImage: self.image, name:self.classification)
                    }
                }
            } else {
                Spacer()
                Text("Take a photo or select an image")
            }
            Spacer()
            HStack(spacing:0) {
                Button(action: {
                    self.showPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Photos")
                            .font(.headline)
                    }
                }
                .buttonStyle(BlueButton())
                Button(action: {
                    self.showCamera = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
                        
                        Text("Camera")
                            .font(.headline)
                    }
                }
                .buttonStyle(BlueButton())
            }
            Divider()
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, completionHandler: onPick)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: self.$image, completionHandler: onPick)
        }
        .sheet(isPresented: $showInfoSheet) {
            BirdInfoSheet(name: $classification)
        }
    }
    
    private func onPick(image: UIImage) -> Void {
        classifyImage(image: image)
    }
    
    private func classifyImage(image: UIImage) {
        do {
            try self.predictor.makePredictions(for: image, completionHandler: imagePredictionHandler)
        } catch {}
    }
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            print("No Prediction")
            return
        }
        let formattedPredictions = formatPredictions(predictions)
        self.classification = formattedPredictions[0]
        print(self.classification)
    }
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }
            if name != "background" {
                let birdInfo = birdData.getInfo(scientific: name)
                self.displayName = birdInfo.common
            }
            return "\(name)";
        }
        
        return topPredictions
    }
}

struct Identify_Previews: PreviewProvider {
    static var previews: some View {
        Identify()
    }
}
