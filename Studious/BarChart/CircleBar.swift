//
//  CircleBar.swift
//  Studious
//
//  Created by Alex on 6/14/24.
//

import SwiftUI

struct CircleBar: View {
    var workSessions: Int
    var breakSessions: Int
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: CGFloat(workSessions) / CGFloat(workSessions + breakSessions))
                .stroke(Color.green, lineWidth: 20)
                .frame(width: 150, height: 150)
            Text("Pomodoro: \(workSessions)")
                .foregroundColor(.green)
                .padding()
        }
        
        VStack {
            Circle()
                .trim(from: 0, to: CGFloat(breakSessions) / CGFloat(workSessions + breakSessions))
                .stroke(Color.blue, lineWidth: 20)
                .frame(width: 150, height: 150)
            Text("Giải Lao: \(breakSessions)")
                .foregroundColor(.blue)
                .padding()
        }
    }
}
