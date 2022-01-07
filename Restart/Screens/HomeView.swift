//
//  HomeView.swift
//  Restart
//
//  Created by Jacob Ko on 2022/01/08.
//

import SwiftUI
struct HomeView: View {
	// MARK: -  PROPERTY
	@AppStorage("onboading") var isOnboadingViewActive: Bool = false
	
	// MARK: -  BODY
	var body: some View {
		VStack (spacing: 20) {
			Text("Home").font(.largeTitle)
			
			Button(action: {
				isOnboadingViewActive = true
			}) {
				Text("Restart")
			}
		} //: VStack
	}
}

// MARK: -  PREVIEW
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
