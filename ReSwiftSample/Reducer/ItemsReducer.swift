//
//  ItemsReducer.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/15.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import Foundation
import ReSwift

func itemsState(action: Action, state: ItemsState?) -> ItemsState {
    var state = state ?? ItemsState()
    
    switch action {
    case _ as RequestStartAction:
        state.isLoading = true
    case _ as ResuestCompletedAction:
        state.isLoading = false
        state.error = nil
    case let action as ResuestFailedAction:
        state.isLoading = false
        state.error = action.error
    case let action as RecievedNewItemsAction:
        state.searchTerms = action.result.queries.request.first?.searchTerms
        state.items = action.result.items
        state.nextIndex = action.result.queries.nextPage.first?.startIndex
    case let action as RecievedNextItemsAction:
        state.items.append(contentsOf: action.result.items)
        state.nextIndex = action.result.queries.nextPage.first?.startIndex
    default:
        break
    }
    
    return state
}
