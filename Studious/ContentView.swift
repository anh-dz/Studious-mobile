import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var selectedTab = 0
    
    init() {
        _selectedTab = State(initialValue: 0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Text("Pomodoro")
                            .foregroundColor(selectedTab == 0 ? .white : .gray)
                            .onTapGesture {
                                selectedTab = 0
                            }
                        Spacer()
                        Text("Thống kê")
                            .foregroundColor(selectedTab == 1 ? .white : .gray)
                            .onTapGesture {
                                selectedTab = 1
                            }
                        Spacer()
                    }
                    .font(.title3)
//                    .bold()
                    .padding()
                
                    
                    TabView(selection: $selectedTab) {
                        WorkTimerView(viewModel: viewModel)
                            .tag(0)
                        
                        ShortTimerView(viewModel: viewModel)
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
