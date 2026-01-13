//
//  ContentView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/16/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    let container = inMemoryContainerForPreviews()
    ContentView()
        .modelContainer(container)
}
