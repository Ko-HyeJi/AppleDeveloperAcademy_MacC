//
//  AskView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/15.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import MessageUI
import UI

struct AskView: View {
  @State var isMailErrorAlertPresented: Bool = false
  @StateObject var coordinator = Coordinator()

  var body: some View {
    Button(action: {
      commentsButtonTapped()
    }, label: {
      LinkLabelView(linkLabel: "문의하기")
    })
    .alert(isPresented: $isMailErrorAlertPresented) {
      Alert(
        title: Text("메일 전송 실패"),
        message: Text("메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요."),
        primaryButton: .default(Text("App Store로 이동하기")) {
          if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
              UIApplication.shared.openURL(url)
            }
          }
        },
        secondaryButton: .destructive(Text("취소"))
      )
    }
  }
  
  func commentsButtonTapped() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
      return
    }
    
    if MFMailComposeViewController.canSendMail() {
      let composeViewController = MFMailComposeViewController()
      composeViewController.mailComposeDelegate = coordinator
      
      let bodyString =
      """
      안녕하세요. Seta 입니다. 아래 내용을 보내주시면 문의 확인에 도움이 됩니다.
      Hello, this is Seta. Providing the following information will help us investigate your inquiry
      
        - iOS 버전(iOS version) :
        - 기기 모델명(Device model) :
        - 문제발생일시(Date and time of issue) :
        - 문의 내용(Details of your inquiry) :
      
      
      """
      
      composeViewController.setToRecipients(["thecreative8team@gmail.com"])
      composeViewController.setSubject("<SETA> 문의 및 의견")
      composeViewController.setMessageBody(bodyString, isHTML: false)
      composeViewController.view.tintColor = .systemBlue
      
      if let presented = rootViewController.presentedViewController {
        presented.dismiss(animated: false) {
          rootViewController.present(composeViewController, animated: true, completion: nil)
        }
      } else {
        rootViewController.present(composeViewController, animated: true, completion: nil)
      }
    } else {
      isMailErrorAlertPresented.toggle()
    }
  }
  
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    func mailComposeController(
      _ controller: MFMailComposeViewController, didFinishWith
      result: MFMailComposeResult,
      error: Error?) {
        controller.dismiss(animated: true, completion: nil)
      }
  }
}

#Preview {
  AskView()
}
