//
//  HomeScreenView.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 26.02.2023.
//

import SwiftUI

struct HomeScreenView: View {
    
    var body: some View {
        VStack {
            Spacer()
            TrackerView()
            Spacer()
            TasksListView()
            Spacer()
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
