//
//  DecodableDataParser.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/15.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }
    
    func parse(data: Data) throws -> Any {
        return data
    }
}
