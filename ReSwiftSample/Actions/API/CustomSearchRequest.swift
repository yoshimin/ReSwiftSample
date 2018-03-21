//
//  CustomSearchRequest.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/15.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import Foundation
import APIKit

class CustomSearchRequest {
    fileprivate let apiKey = "AIzaSyB_Qv-Os6-i_IjrxGcP_E32wdQvaqBqws8"
    fileprivate let engineId = "001179429966126048106:21bzmez7pk8"
    fileprivate let searchType = "image"
    
    let keyword: String
    let startIndex: Int?
    
    init(keyword: String, startIndex: Int? = nil) {
        self.keyword = keyword
        self.startIndex = startIndex
    }
}

extension CustomSearchRequest: Request {
    typealias Response = CustomSearchResult
    
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/customsearch/v1"
    }
    
    var queryParameters: [String: Any]? {
        var params = ["key": apiKey,
                      "cx": engineId,
                      "searchType": searchType,
                      "q": keyword]
        if let startIndex = startIndex {
            params["start"] = String(startIndex)
        }
        return params
    }
    
    var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
