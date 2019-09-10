//
//  HostingController.swift
//  DemoCrashApp WatchKit Extension
//
//  Created by Joshua Archer on 9/10/19.
//  Copyright © 2019 Scope. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import Combine
import SwiftUIFlux

class HostingController: WKHostingController<StoreProvider<AppState, ContentView>> {

    let store = Store<AppState>(reducer: appStateReducer, middleware: [loggingMiddleware], state: AppState())

    override var body: StoreProvider<AppState, ContentView> {
        return StoreProvider(store: self.store) {
            ContentView()
        }
    }
}

public struct AppState: FluxState {

    public var rankingState: RankingState
    public init() {
        self.rankingState = RankingState(ranking: RankingState.Ranking(rank: 1))
    }
}

public func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    state.rankingState = rankingStateReducer(state: state.rankingState, action: action)
    return state
}

public let loggingMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            #if DEBUG
            let name = __dispatch_queue_get_label(nil)
            let queueName = String(cString: name, encoding: .utf8)
            print("#Action: \(String(reflecting: type(of: action))) on queue: \(queueName ?? "??")")
            #endif
            return next(action)
        }
    }
}

public struct RankingState: FluxState {
    var ranking: Ranking
    public struct Ranking {
        var rank: Int

    }
}

public struct RankingActions {

    struct SetRanking: Action {
        var ranking: RankingState.Ranking
    }
}

func rankingStateReducer(state: RankingState, action: Action) -> RankingState {
    var state = state
    switch action {
    case let action as RankingActions.SetRanking:
        state.ranking = action.ranking
    default:
        break
    }
    return state
}
