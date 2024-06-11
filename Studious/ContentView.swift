//
//  ContentView.swift
//  Studious
//
//  Created by Alex on 6/10/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color(viewModel.isBreakTime ? .white : .purple).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Picker(selection: $viewModel.selectedSubject, label: Text(viewModel.selectedSubject)) {
                    ForEach(viewModel.subjects, id: \.self) { subject in
                        Text(subject)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(viewModel.isBreakTime ? .blue : .white)
                .padding()
                .onChange(of: viewModel.selectedSubject) { newValue in
                    viewModel.updateTimes(for: newValue)
                }
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                        .shadow(color: .black, radius: 10, x: 0, y: 0)
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / CGFloat(viewModel.isBreakTime ? viewModel.timings[viewModel.selectedSubject]!.break : viewModel.timings[viewModel.selectedSubject]!.work))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(viewModel.isBreakTime ? .blue : .green)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut)
                    
                    Text("\(viewModel.timeString(time: viewModel.timeRemaining))")
                        .font(.largeTitle)
                        .foregroundColor(viewModel.isBreakTime ? .black : .white)
                }
                .frame(width: 200, height: 200)
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.stopTimer()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        if viewModel.isTimerRunning {
                            viewModel.pauseTimer()
                        } else {
                            viewModel.startTimer()
                        }
                    }) {
                        Image(systemName: viewModel.isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.isTimerRunning ? .orange : Color(red: 131/255, green: 180/255, blue: 255/255))
                    }
                    
                    Button(action: {
                        viewModel.nextSession()
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
