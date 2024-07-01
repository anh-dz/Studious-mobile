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
    
    @State private var showingChart = false
    @State private var showingHelp = false
    @State private var showingBreath = false
    
    var body: some View {
        VStack {
            Button(action: {
                showingChart.toggle()
            }) {
                Text("Biểu đồ")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Image(systemName: "chart.pie.fill")
                    .font(.title)
                    .foregroundColor(.green)
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
                Text("Hít thở")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Image(systemName: "staroflife.circle.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
            }
            .sheet(isPresented: $showingBreath) {
                BreathView()
            }
            
            Divider()
              .frame(width: 200, height: 2)
              .background(Color.white)
              .padding(.horizontal, 16)
            
            Button(action: {
                showingHelp.toggle()
            }) {
                Text("Giới thiệu")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Image(systemName: "info.circle.fill")
                    .font(.title)
                    .foregroundColor(Color.gray)
            }
            .sheet(isPresented: $showingHelp) {
                HelpView()
            }
            
            Spacer()
        }
        .padding(32)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SlideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenu(w: 5, b: 3)
    }
}
