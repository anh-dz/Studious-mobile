//
//  AboutView.swift
//  Studious
//
//  Created by Alex on 6/19/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("Giới thiệu về Studious")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Studious - Ứng dụng Học tập và Quản lý Thời gian Hoàn hảo.")
                .multilineTextAlignment(.center)
            
            Text("Phát triển: Nhật Anh, Nhật Huy")
                .multilineTextAlignment(.center)
            
            Text("Studious được định hướng là một ứng dụng đa chức năng thiết kế đặc biệt để hỗ trợ việc học tập và quản lý thời gian một cách hiệu quả.")
                .multilineTextAlignment(.center)
            
            Text("Ngoài các tính năng như Pomodoro, Thống kê thời gian học tập, Theo dõi công việc tuần, Botchat AI giải bài tập, Thư giãn, Studious còn cung cấp một không gian để kết nối với cộng đồng học tập. Bạn có thể chia sẻ những trải nghiệm, học hỏi từ những người khác và tạo ra sự động viên tinh thần cho nhau.")
                .multilineTextAlignment(.center)
            
            Text("Mọi thông tin chi tiết liên hệ:")
                .multilineTextAlignment(.center)
            
            Text("E-mail: nmnanh1235@gmail.com")
                .multilineTextAlignment(.center)
            
            Text("SDT: 0388029188")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
