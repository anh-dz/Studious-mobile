//
//  ViewModel.swift
//  Studious
//
//  Created by Alex on 6/10/24.
//

import Foundation
import AVFoundation

class ViewModel: ObservableObject {
    @Published var isTimerRunning = false
    @Published var isBreakTime = false
    @Published var timeRemaining: Int
    @Published var selectedSubject: String
    
    let subjects = ["Math", "Literature", "English"]
    let timings: [String: (work: Int, break: Int)] = [
        "Math": (25 * 60, 5 * 60),
        "Literature": (60 * 60, 10 * 60),
        "English": (30 * 60, 5 * 60)
    ]
    
    private var timer: Timer?
    
    init() {
        let defaultSubject = "Math"
        self.selectedSubject = defaultSubject
        if let times = timings[defaultSubject] {
            self.timeRemaining = times.work
        } else {
            self.timeRemaining = 25 * 60
        }
    }
    
    func startTimer() {
        isTimerRunning = true
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.playSystemSound()
                    if self.isBreakTime {
                        self.resetToWorkTime()
                    } else {
                        self.setToBreakTime()
                    }
                    self.isTimerRunning = false
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
        resetToWorkTime()
    }
    
    func nextSession() {
        if isBreakTime {
            resetToWorkTime()
        } else {
            setToBreakTime()
        }
    }
    
    func updateTimes(for subject: String) {
        selectedSubject = subject
        if let times = timings[subject] {
            timeRemaining = times.work
        }
    }
    
    private func resetToWorkTime() {
        if let times = timings[selectedSubject] {
            timeRemaining = times.work
        }
        isBreakTime = false
    }
    
    private func setToBreakTime() {
        if let times = timings[selectedSubject] {
            timeRemaining = times.break
        }
        isBreakTime = true
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func playSystemSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1304))
    }
}
