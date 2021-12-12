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
    @State private var otherPredictions: [String] = [];
    @State private var displayName: String = "";
    @State private var imageSaved: Bool = false;
    
    @ObservedObject var birdData = ReadData()
    let screenSize: CGRect = UIScreen.main.bounds
    
    let predictor = ImagePredictor()
    let predictionsToShow = 5;
    
    var body: some View {
        VStack {
            if classification != "" {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight:screenSize.height-250)
                .overlay(alignment:.bottomLeading) {
                    if classification != "" {
                        IdentifyViewClassification(classification: self.classification, displayName: (classification == birdData.getInfo(scientific: classification).scientific) ? self.displayName: getGenusSpecies(s: classification), predictionList: otherPredictions, showInfoSheet: self.$showInfoSheet)
                    }
                }
                .overlay(alignment:.topLeading) {
                    if classification != "" && classification != "background" {
                        SaveObservationButton(observedImage: self.$image, name:self.$classification, saved: self.$imageSaved)
                    }
                }
            } else {
                Spacer()
                Text("Take a photo or select an image")
            }
            Spacer()
            HStack(spacing:0) {
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
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
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
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
    
    private func getGenusSpecies(s: String) -> String {
        let genus = s.components(separatedBy: " ")[0]
        let genusData: [Bird] = birdData.getGenus(genus: genus)
        return genusData[0].common
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
        self.otherPredictions = formattedPredictions
        self.classification = formattedPredictions[0]
        Haptics.shared.notify(.success)
        if formattedPredictions[0] != "background" {
            let birdInfo = birdData.getInfo(scientific: formattedPredictions[0])
            self.displayName = birdInfo.common
            self.imageSaved = false;
        }
    }
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
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
