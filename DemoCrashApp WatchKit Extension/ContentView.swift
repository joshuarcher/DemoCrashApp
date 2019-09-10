//
//  ContentView.swift
//  DemoCrashApp WatchKit Extension
//
//  Created by Joshua Archer on 9/10/19.
//  Copyright © 2019 Scope. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct ContentView: ConnectedView {

    struct Props {
        let rank: Int
        let onButtonTap: () -> Void
    }

    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {

        let rank = state.rankingState.ranking.rank
        let onButtonTap = {
            dispatch(RankingActions.SetRanking(ranking: RankingState.Ranking(rank: rank + 1)))
        }
        return Props(rank: rank, onButtonTap: onButtonTap)
    }

    func body(props: Props) -> some View {
        VStack {
            Text("Rank")
            Text("#\(props.rank)")
            Button(action: {
                props.onButtonTap()
            }) {
                Text("Increment")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
