//
//  AvatarImage.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 12.05.17.
//
//

import Foundation
import Moya


enum AvatarImage {
    case download(URL)
}


extension AvatarImage: TargetType {
    
    public var baseURL: URL {
        
        switch self {
        case.download(let url):
            return url
        }
    }
    
    public var path: String {
        
        return ""
    }
    
    public var method: Moya.Method {
        
        return .get
    }
    
    public var parameters: [String: Any]? {
        
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        
        return URLEncoding.default
    }
    
    public var sampleData: Data {
        
        return "{}".data(using: .utf8)!
    }
    
    public var task: Task {
        
        return .request
    }
}
