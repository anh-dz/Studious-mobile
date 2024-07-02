//
//  SlideMenu.swift
//  Studious
//
//  Created by Alex on 7/1/24.
//

import SwiftUI

struct SlideMenu: View {
    var w: Int
    var b: Int
    
    @Binding var userCode: String
    
    @State private var showingChart = false
    @State private var showingHelp = false
    @State private var showingBreath = false
    
    @State private var isPresentingScanner = false
    @State private var isPresentingImagePicker = false
    @State private var showAlert = false
    @State private var scannedCode: String? {
        didSet {
            if let code = scannedCode, code != userCode {
                userCode = code
            }
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                showingChart.toggle()
            }) {
                HStack {
                    Text("Biểu đồ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: "chart.pie.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
            .sheet(isPresented: $showingChart) {
                ChartView(w: w, b: b)
            }
            
            Divider()
              .frame(width: 200, height: 2)
              .background(Color.white)
              .padding(.horizontal, 16)
            
            Button(action: {
                showingBreath.toggle()
            }) {
                HStack {
                    Text("Hít thở")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: "staroflife.circle.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                }
            }
            .sheet(isPresented: $showingBreath) {
                BreathView()
            }
            
            Divider()
              .frame(width: 200, height: 2)
              .background(Color.white)
              .padding(.horizontal, 16)
            
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    isPresentingScanner = true
                } else {
                    showAlert = true
                }
            }) {
                HStack {
                    Text("Đồng bộ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: "qrcode")
                        .font(.title)
                        .foregroundColor(Color("blue"))
                }
            }
            .sheet(isPresented: $isPresentingScanner) {
                QRCodeScannerView(scannedCode: $scannedCode)
            }
            .sheet(isPresented: $isPresentingImagePicker) {
                ImagePicker(scannedCode: $scannedCode)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Camera Not Available"),
                    message: Text("Your device does not have a camera. Would you like to select a photo from the library instead?"),
                    primaryButton: .default(Text("Yes")) {
                        isPresentingImagePicker = true
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Divider()
              .frame(width: 200, height: 2)
              .background(Color.white)
              .padding(.horizontal, 16)
            
            Button(action: {
                showingHelp.toggle()
            }) {
                HStack {
                    Text("Giới thiệu")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: "info.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.gray)
                }
            }
            .sheet(isPresented: $showingHelp) {
                HelpView()
            }
            
            Spacer()
        }
        .padding(25)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SlideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenu(w: 5, b: 3, userCode: .constant("studious"))
    }
}
