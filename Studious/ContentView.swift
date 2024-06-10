//
//  ContentView.swift
//  Studious
//
//  Created by Alex on 6/10/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    let subjects = ["Math", "Literature", "English"] // Subjects array
    let workTime = 25 * 60
    let breakTime = 0 * 60

    @State private var timer: Timer?
    @State private var isTimerRunning = false
    @State private var isBreakTime = false
    @State private var timeRemaining = 25 * 60
    @State private var selectedSubject = "Math" // Default subject

    var body: some View {
        ZStack {
            Color(isBreakTime ? .white : .purple).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // ComboBox for selecting subjects
                Picker(selection: $selectedSubject, label: Text(selectedSubject)) {
                    ForEach(subjects, id: \.self) { subject in
                        Text(subject)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Style the picker
                .foregroundColor(isBreakTime ? .blue : .white)
                .padding()
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                        .shadow(color: .black, radius: 10, x: 0, y: 0) // Add shadow effect
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(isBreakTime ? self.breakTime : self.workTime)) // Max time for work: 25 minutes, for break: 5 minutes
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(isBreakTime ? .blue : .green)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut)
                    
                    Text("\(timeString(time: timeRemaining))")
                        .font(.largeTitle)
                        .foregroundColor(isBreakTime ? .black : .white)
                }
                .frame(width: 200, height: 200)
                
                HStack(spacing: 20) {
                    Button(action: {
                        if isTimerRunning {
                            pauseTimer()
                        } else {
                            startTimer()
                        }
                    }) {
                        Image(systemName: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(isTimerRunning ? .orange : Color(red: 131/255, green: 180/255, blue: 255/255))
                    }
                    
                    Button(action: {
                        stopTimer()
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        nextSession()
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
    
    func startTimer() {
        isTimerRunning = true
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.invalidate()
                    timer = nil
                    if isBreakTime {
                        viewModel.playSystemSound()
                        timeRemaining = self.workTime // Reset to work time
                        isBreakTime = false
                    } else {
                        viewModel.playSystemSound()
                        timeRemaining = self.breakTime // Set to break time
                        isBreakTime = true
                    }
                    isTimerRunning = false
                }
            }
        }
    }
    
    func pauseTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        timeRemaining = self.workTime // Reset to initial work time
        isBreakTime = false
    }
    
    func nextSession() {
        if isBreakTime {
            timeRemaining = self.workTime // Reset to work time
            isBreakTime = false
        } else {
            timeRemaining = self.breakTime // Set to break time
            isBreakTime = true
        }
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
