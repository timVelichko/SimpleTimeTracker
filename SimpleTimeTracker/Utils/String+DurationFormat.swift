//
//  String+DurationFormat.swift
//  SimpleTimeTracker
//
//  Created by Tim Vialichka on 26.02.2023.
//

import Foundation

extension String {
    
    init(_ duration: TimeInterval) {
        let hours = Int(duration / 3600)
        let minutesAndSeconds = Double(duration - TimeInterval(hours * 3600))
        let minutes = Int(minutesAndSeconds / 60)
        let seconds = Int(minutesAndSeconds - TimeInterval(minutes * 60))
        self.init(format: "%tu:%02tu:%02tu", hours, minutes, seconds)
    }
    
}
