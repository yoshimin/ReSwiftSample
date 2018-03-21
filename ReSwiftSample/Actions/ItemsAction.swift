//
//  ItemsAction.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/15.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import ReSwift
import APIKit

struct RequestStartAction: Action{}

struct ResuestCompletedAction: Action{}

struct ResuestFailedAction: Action{
    let error: SessionTaskError
}

struct RecievedNewItemsAction: Action {
    let result: CustomSearchResult
}

struct RecievedNextItemsAction: Action {
    let result: CustomSearchResult
}

struct ItemsActionCreator {
    
    static func load<Request: CustomSearchRequest>(request: Request) -> Store<ItemsState>.AsyncActionCreator {
        return send(request: request, action: .load)
    }
    
    static func loadMore<Request: CustomSearchRequest>(request: Request) -> Store<ItemsState>.AsyncActionCreator {
        return send(request: request, action: .loadMore)
    }
}

private extension ItemsActionCreator {
    enum ActionType {
        case load
        case loadMore
    }
    
    static func send<Request: CustomSearchRequest>(request: Request, action: ActionType) -> Store<ItemsState>.AsyncActionCreator {
        return { (state, store, callback) in
            if state.isLoading {
                return
            }
            
            callback { _,_ in
                RequestStartAction()
            }
            
            Session.send(request) { result in
                switch result {
                case .success(let response):
                    callback { _,_ in
                        switch action {
                        case .load:
                            return RecievedNewItemsAction(result: response)
                        case .loadMore:
                            return RecievedNextItemsAction(result: response)
                        }
                    }
                    callback { _,_ in
                        ResuestCompletedAction()
                    }
                case .failure(let error):
                    callback { _,_ in
                        ResuestFailedAction(error: error)
                    }
                    print(error)
                }
            }
        }
    }
}
