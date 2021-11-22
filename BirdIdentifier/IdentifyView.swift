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
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight:screenSize.height-250)
                .overlay(alignment:.bottomLeading) {
                    if classification != "" {
                        VStack {
                            VStack {
                                if classification == "background" {
                                    Text("Unable to Classify")
                                        .padding(10)
                                        .foregroundColor(Color.black)
                                        .shadow(radius: 5)
                                        .background(
                                            Color(red: 238/255,
                                                  green:238/255, blue: 238/255)
                                        )
                                        .opacity(1)
                                        .cornerRadius(20)
                                } else {
                                    Button(action: {
                                        self.showInfoSheet = true
                                    }) {
                                        VStack(alignment:.leading) {
                                            HStack {
                                                Text("\(displayName) \(Image(systemName: "chevron.right"))")
                                                    .bold()
                                                .foregroundColor(Color.black)
                                                Spacer()
                                            }
                                            Text("\(classification)")
                                                .foregroundColor(Color.gray)
                                        }
                                        
                                    }
                                    .padding()
                                    .background(
                                        Color(red: 238/255, green:238/255, blue: 238/255)
                                    )
                                    .cornerRadius(20)
                                    .frame(maxWidth:.infinity)
                                    .shadow(radius: 5)
                                }
                            }
                        }
                        .padding()
                    }
                }
            
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
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding()
                }
                Button(action: {
                    self.showCamera = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
                        
                        Text("Camera")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            }
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
        } catch {
            print("Vision was unable to make a prediction")
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            print("No Prediction")
            return
        }
        let formattedPredictions = formatPredictions(predictions)
        self.classification = formattedPredictions[0]
        
    }
    
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification
            
            // For classifications with more than one name, keep the one before the first comma.
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
