//
//  ViewModel.swift
//  Studious
//
//  Created by Alex on 6/10/24.
//
import Foundation
import AVFoundation

class ViewModel: ObservableObject {
    func playSystemSound() {
        let systemSoundID: SystemSoundID = 1304 // You can find different system sound IDs from documentation
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
