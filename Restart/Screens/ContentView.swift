//
//  ContentView.swift
//  Restart
//
//  Created by Jacob Ko on 2022/01/07.
//

import SwiftUI

struct ContentView: View {
	// MARK: -  PROPERTY
	// @AppStorage wrapper will be stored permenatly in the local storage
	@AppStorage("onboading") var isOnboadingViewActive: Bool = true
	
	// MARK: -  BODY
	var body: some View {
		ZStack {
			if isOnboadingViewActive {
				OnboardingView()
			} else {
				HomeView()
			}
		}
	}
}

// MARK: -  PREVIEW
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
