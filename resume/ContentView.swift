//
//  ContentView.swift
//  resume
//
//  Created by HY on 4/28/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = RebuildStore()

    var body: some View {
        RootTabView()
            .environmentObject(store)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
