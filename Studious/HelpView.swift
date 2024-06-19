//
//  HelpView.swift
//  Studious
//
//  Created by Alex on 6/15/24.
//

import SwiftUI
import SafariServices
import MessageUI

struct HelpView: View {
    
    @State var showPomodoro = false
    @State var pomoURL = "https://vi.wikipedia.org/wiki/Ph%C6%B0%C6%A1ng_ph%C3%A1p_qu%E1%BA%A3_c%C3%A0_chua"
    @State var showDev = false
    @State var devURL = ""
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingShareView = false
    @State var resetStats = false
    @Environment(\.presentationMode) var presentationMode
    let selection = UISelectionFeedbackGenerator()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "info.circle.fill")
                    .font(Font.system(.largeTitle, design: .rounded))
                    .padding()
                    .foregroundColor(Color("accent"))
                Text("Giới thiệu")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("accent"))
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 20) {
                    HStack(alignment: .bottom, spacing: 20) {
                        
                        Button(action: {
                            // About Pomodoro
                            self.selection.selectionChanged()
                            self.showPomodoro = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .foregroundColor(Color("accent"))
                                VStack {
                                    Image(systemName: "timer")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("Giới thiệu về Pomodoro")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                            
                        }
                        .sheet(isPresented: $showPomodoro) {
                            SafariView(url: URL(string: self.pomoURL)!)
                        }
                        
                        Button(action: {
                            // About the Developer
                            self.selection.selectionChanged()
                            self.showDev = true
                        }) {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                .foregroundColor(Color("accent"))
                                VStack {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("Giới thiệu nhà phát triển")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .sheet(isPresented: $showDev) {
                            AboutView()
                        }
                        
                    }
                    
                    HStack(alignment: .bottom, spacing: 20) {
                        Button(action: {
                            self.selection.selectionChanged()
                            if MFMailComposeViewController.canSendMail() {
                                UIApplication.shared.open(URL(string: "mailto:nmnanh1235@gmail.com")!)
                            } else if UIApplication.shared.canOpenURL(URL(string: "readdle-spark://compose?recipient=nmnanh1235@gmail.com")!) {
                                UIApplication.shared.open(URL(string: "readdle-spark://compose?recipient=nmnanh1235@gmail.com")!)
                            } else if UIApplication.shared.canOpenURL(URL(string: "airmail://compose?to=nmnanh1235@gmail.com")!) {
                                UIApplication.shared.open(URL(string: "airmail://compose?to=nmnanh1235@gmail.com")!)
                            } else {
                                self.isShowingShareView.toggle()
                            }
                        }) {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                VStack {
                                    Image(systemName: "envelope.circle.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("Hỗ trợ")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .sheet(isPresented: $isShowingShareView) {
                            ShareSheet()
                        }
                        
                        Button(action: {
                            // Reset Stats
                            self.selection.selectionChanged()
                            self.resetStats.toggle()
                        }) {
                            ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                VStack {
                                    Image(systemName: "0.circle.fill")
                                        .foregroundColor(.white)
                                        .font(Font.system(.largeTitle, design: .rounded))
                                        .padding(.bottom)
                                    Text("Reset dữ liệu")
                                        .foregroundColor(.white)
                                        .font(Font.system(.headline, design: .rounded))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .alert(isPresented: self.$resetStats) { () -> Alert in
                            Alert(title: Text("Bạn có chắc chắn"), message: Text("\(NSLocalizedString("Điều này sẽ xoá toàn bộ dữ liệu của bạn", comment: "Điều này sẽ xoá toàn bộ dữ liệu của bạn")) \(UIDevice.current.name)"), primaryButton: .destructive(Text("Xoá dữ liệu"), action: {
                                UserDefaults.standard.synchronize()
                                UserDefaults.standard.set(0, forKey: "workSessionsCompleted")
                                UserDefaults.standard.set(0, forKey: "breakSessionsCompleted")
                                UserDefaults.standard.synchronize()
                            }), secondaryButton: .cancel())
                        }
                        
                    }
                }
                .padding(.bottom)
                
            }
            Spacer()
        }
        .background(Color("background").edgesIgnoringSafeArea(.all))
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
            .environment(\.locale, Locale(identifier: "es"))
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}

struct ShareSheet: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: ["nmnanh1235@gmail.com"], applicationActivities: nil)
        return controller
    }
      
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
