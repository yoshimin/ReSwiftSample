//
//  ItemsState.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/10.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import ReSwift
import APIKit

struct ItemsState: StateType {
    var searchTerms: String? = nil
    var items: [Item] = []
    var nextIndex: Int? = nil
    var isLoading: Bool = false
    var error: SessionTaskError? = nil
}
