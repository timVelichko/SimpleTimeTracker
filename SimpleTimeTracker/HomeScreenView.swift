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
            Text("Hello, world!")
            Spacer()
        }
        .padding()
//        .background(.blue)
    }
}

struct TrackerView: View {
    
    @State private var isTracking: Bool = false {
        didSet {
            buttonTitle = LocalizedStringKey(isTracking ? "homeScreen.stop" : "homeScreen.start")
            buttonColor = isTracking ? .red : .green
            
            if isTracking == false {
                taskTitle = ""
            }
        }
    }
    @State private var buttonTitle: LocalizedStringKey = LocalizedStringKey("homeScreen.start")
    @State private var buttonColor: Color = .green
    @State private var taskTitle: String = ""
    
    enum Field: Int, Hashable {
        case trackTitle
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack(spacing: 15) {
            Button {
                isTracking.toggle()
            } label: {
                Text(buttonTitle)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .background(buttonColor)
                    .clipShape(Circle())
            }
            Text("00:00")
                .font(.title)
            HStack(spacing: 8) {
                TextField("homeScreen.taskTitlePlaceholder", text: $taskTitle)
                .frame(width: 250)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .trackTitle)
                .onSubmit {
                    if isTracking == false {
                        isTracking = true
                    }
                }
                
                Button {
                    focusedField = .trackTitle
                } label: {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }

            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
