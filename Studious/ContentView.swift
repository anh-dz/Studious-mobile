import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var workTime = 25 * 60
    @State private var breakTime = 5 * 60
    @State private var timer: Timer?
    @State private var isTimerRunning = false
    
    @State var subjects = ["Pomodoro"]
    @State var timings: [String: (work: Int, break: Int)] = ["Pomodoro": (25 * 60, 5 * 60)]
    @AppStorage("isBreakTime") private var isBreakTime = false
    @AppStorage("timeRemaining") private var timeRemaining = 25 * 60
    @AppStorage("selectedSubject") private var selectedSubject = "Pomodoro"
    
    @AppStorage("workSessionsCompleted") private var workSessionsCompleted = 0
    @AppStorage("breakSessionsCompleted") private var breakSessionsCompleted = 0
    
    @AppStorage("userCode") var userCode = "studious"
    
    @State private var showingChart = false
    @State private var showingHelp = false
    @State var breathViewOn = false
    @State private var showMenu = false
    
    @State private var oldUserCode: String = "studious"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(isBreakTime ? .white : .purple).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Picker(selection: $selectedSubject, label: Text(selectedSubject)) {
                        ForEach(subjects, id: \.self) { subject in
                            Text(subject)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(isBreakTime ? .blue : .white)
                    .padding()
                    .onChange(of: selectedSubject) { newValue in
                        updateTimes(for: newValue)
                        selectedSubject = newValue
                    }
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                            .foregroundColor(.gray)
                            .shadow(color: .black, radius: 10, x: 0, y: 0)
                        Circle()
                            .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(isBreakTime ? self.breakTime : self.workTime))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(isBreakTime ? .blue : .green)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut)
                        
                        Text("\(timeString(time: timeRemaining))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(isBreakTime ? .black : .white)
                    }
                    .frame(width: 200, height: 200)
                    .padding()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            stopTimer()
                        }) {
                            Image(systemName: "stop.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            if isTimerRunning {
                                playStopSound()
                                pauseTimer()
                            } else {
                                playStartSound()
                                startTimer()
                            }
                        }) {
                            Image(systemName: isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(isTimerRunning ? .orange : Color(red: 131/255, green: 180/255, blue: 255/255))
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
                GeometryReader { _ in
                  HStack {
                    Spacer()
                    SlideMenu(w: workSessionsCompleted, b: breakSessionsCompleted, userCode: $userCode)
                      .offset(x: showMenu ? 0 : UIScreen.main.bounds.width)
                      .animation(.easeInOut(duration: 0.4), value: showMenu)
                  }
                }
                .background(Color.black.opacity(showMenu ? 0.6 : 0))
                .edgesIgnoringSafeArea(.bottom)
                .onChange(of: showMenu) { newValue in
                    if !newValue && oldUserCode != userCode {
                        oldUserCode = userCode
                        fetchTimingsFromServer()
                        updateTimes(for: selectedSubject)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Studious")
            .toolbar {
                Button {
                    self.showMenu.toggle()
                } label: {
                    if showMenu {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "text.justify")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            fetchTimingsFromServer()
            updateTimes(for: selectedSubject)
            oldUserCode = userCode
        }
    }
    
    private func fetchTimingsFromServer() {
        ServerManager.shared.fetchTimings { fetchedData in
            if let fetchedData = fetchedData {
                DispatchQueue.main.async {
                    self.updateTimings(with: fetchedData)
                }
            }
        }
    }
    
    private func postSessionData() {
        ServerManager.shared.postSessionData(subject: selectedSubject, workTime: workTime, timeRemaining: timeRemaining)
    }
    
    private func updateTimings(with fetchedData: [String: ComboData]) {
        timings = [:]
        subjects = []
        for (_, comboData) in fetchedData {
            timings[comboData.combo] = (work: comboData.work * 60, break: comboData.rest * 60)
            subjects.append(comboData.combo)
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
                    playSystemSound()
                    if isBreakTime {
                        breakSessionsCompleted += 1
                        timeRemaining = self.workTime
                        isBreakTime = false
                    } else {
                        workSessionsCompleted += 1
                        timeRemaining = self.breakTime
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
        timeRemaining = self.workTime
        isBreakTime = false
    }
    
    func nextSession() {
        if isBreakTime {
            timeRemaining = self.workTime
            isBreakTime = false
        } else {
            postSessionData()
            timeRemaining = self.breakTime
            isBreakTime = true
        }
    }
    
    func updateTimes(for subject: String) {
        if let times = timings[selectedSubject] {
            workTime = times.work
            breakTime = times.break
        }
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func playSystemSound() {
        let systemSoundID: SystemSoundID = 1304
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func playStartSound() {
        let systemSoundID: SystemSoundID = 1113
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func playStopSound() {
        let systemSoundID: SystemSoundID = 1114
        AudioServicesPlaySystemSound(systemSoundID)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
