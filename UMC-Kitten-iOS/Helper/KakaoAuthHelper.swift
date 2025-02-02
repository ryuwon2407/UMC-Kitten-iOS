//
//  KakaoLoginService.swift
//  UMC-Kitten-iOS
//
//  Created by DOYEON LEE on 2/10/24.
//

import Foundation

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

/// 카카오 로그인 SDK 관련 동작 모음
class KakaoAuthHelper {
    /// 카카오 SDK 초기 설정
    static func initializeKakaoAuthSdk() {
        guard let kakaoAuthAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_AUTH_APP_KEY") as? String else {
            fatalError("KAKAO_AUTH_APP_KEY is not set in Info.plist")
        }
        
        KakaoSDK.initSDK(appKey: kakaoAuthAppKey)
    }
    
    /// 카카오톡 로그인을 위해 카카오톡 앱으로 이동합니다.
    ///
    /// - Parameter completion:- 카카오톡 로그인 성공 시 호출될 클로저입니다. 컴플리션으로 토큰 전달합니다.
    static func openKakaoTalkLogin(completion: @escaping (String) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print("kakao login error: \(error)")
                }
                else {
                    completion(oauthToken?.accessToken ?? "")
                }
            }
        }
    }
}
