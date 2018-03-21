//
//  Item.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/10.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import Foundation

struct CustomSearchResult: Decodable {
    let queries: Queries
    let items: [Item]
}

struct Queries: Decodable {
    let request: [Page]
    let nextPage: [Page]
}

struct Page: Decodable {
    let searchTerms: String
    let count: Int
    let startIndex: Int
}

struct Item: Decodable {
    let title: String
    let image: Image
    let link: String
    let displayLink: String
}

struct Image: Decodable {
    let contextLink: String
    let height: Int
    let width: Int
    let thumbnailLink: URL?
    let thumbnailHeight: Int
    let thumbnailWidth: Int
}
