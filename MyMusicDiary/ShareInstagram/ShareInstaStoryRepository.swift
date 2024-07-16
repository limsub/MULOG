//
//  ShareInstaStoryRepository.swift
//  MyMusicDiary
//
//  Created by 임승섭 on 7/15/24.
//

import UIKit

class ShareInstaStoryRepository {
    
    var sharedView: UIView  // 공유할 뷰
    
    init(_ sharedView: UIView) {
        self.sharedView = sharedView
    }
    
//    init() {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        view.backgroundColor = .red
//        sharedView = view
//    }
    
    
    func shareToInstaStory() {
        // png 이미지
        let image = sharedView.asRenderedImage()
        guard let imageData = image.pngData() else { return }
        
        
        // 옵션
        let pastedboardItems: [String: Any] = [
            "com.instagram.sharedSticker.stickerImage": imageData,
            "com.instagram.sharedSticker.backgroundTopColor" : "#ebe88a",
            "com.instagram.sharedSticker.backgroundBottomColor" : "#73c1b2"
        ]
        
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
        ]
        
        
        // 공유 세팅
        UIPasteboard.general.setItems(
            [pastedboardItems],
            options: pasteboardOptions
        )
        
        // 공유
        if isInstagramInstalled() {
            // 인스타 스토리 공유
            guard let instaURL = URL(string: "instagram-stories://share?source_application=" + "843865771035164") else { return }
            
            UIApplication.shared.open(instaURL, options: [:], completionHandler: nil)
            
        } else {
            // 앱스토어 연결
            guard let instagramURL = URL(string: "https://apps.apple.com/kr/app/instagram/id389801252") else {
                return
            }
            return UIApplication.shared.open(instagramURL)
        }
    }
    
}


extension ShareInstaStoryRepository {
    // 인스타그램이 설치되어 있는지 확인
    private func isInstagramInstalled() -> Bool {
        guard let instaURL = URL(string: "instagram-stories://share?source_application=" + "843865771035164") else { return false }
        
        return UIApplication.shared.canOpenURL(instaURL)
    }
}
