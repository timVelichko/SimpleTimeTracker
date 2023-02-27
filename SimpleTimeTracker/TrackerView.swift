//
//  TrackerView.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 27.02.2023.
//

import SwiftUI

struct TrackerView: View {
    
    init(viewModel: TrackerViewModel = TrackerViewModel()) {
        self.viewModel = viewModel
    }
    
    @ObservedObject var viewModel: TrackerViewModel
    
    enum Field: Int, Hashable {
        case trackTitle
    }
    @FocusState private var focusedField: Field?
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        let color: Color = viewModel.isTracking ? .red : .green
        
        VStack(spacing: 15) {
            Button {
                viewModel.trackerButtonTapped()
            } label: {
                Text(LocalizedStringKey(viewModel.buttonTitle))
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .background(color)
                    .clipShape(Circle())
            }
            Text(viewModel.timerTitle)
                .font(.title)
            HStack(spacing: 8) {
                TextField("homeScreen.taskTitlePlaceholder", text: $viewModel.taskTitle)
                .frame(width: 250)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .trackTitle)
                .onSubmit { viewModel.titleSubmited() }
                
                Button {
                    focusedField = .trackTitle
                } label: {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }

            }
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                viewModel.recalculateTimer()
            default:
                break
            }
        }
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
    }
}
