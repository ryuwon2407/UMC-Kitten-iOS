//
//  UserApiClient.swift
//  UMC-Kitten-iOS
//
//  Created by DOYEON LEE on 2/11/24.
//

import Foundation

import Moya

/// 로그인 관련 API
enum UserApiClient {
    case kakaoLogin(accessToken: String)
    case naverLogin(accessToken: String)
}

extension UserApiClient: TargetType {
    
    var baseURLString: String {
        guard let apiBaseURLString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL is not set in Info.plist")
        }
        return apiBaseURLString
    }
    
    var baseURL: URL {
        let urlString = baseURLString + ""
        guard let url = URL(string: urlString) else {
            fatalError("Constructed URL is invalid: \(urlString)")
        }
        return url
        
    }
    
    var path: String {
        switch self {
        case let .kakaoLogin(accessToken):
            return "/kakao?accessToken=\(accessToken)"
        case let .naverLogin(accessToken):
            return "/naver?accessToken=\(accessToken)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .naverLogin:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .kakaoLogin, .naverLogin:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
