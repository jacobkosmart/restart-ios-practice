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
	@State private var isAnimating: Bool = false
	

	// MARK: -  BODY
	var body: some View {
		VStack (spacing: 20) {
			
			// MARK: -  HEADER
			
			Spacer()
			
			ZStack {
				// Reusable Component
				CircleGroupView(ShapeColor: .gray, ShapeOpacity: 0.1)
				
				Image("character-2")
					.resizable()
					.scaledToFit()
				.padding()
				// Reapeat Animation
				.offset(y: isAnimating ? 35 : -35)
				.animation(
					Animation
						.easeInOut(duration: 4)
						.repeatForever()
					, value: isAnimating
				)
			}
			
			// MARK: -  CENTER
			
			Text("The time that leads to mastery is dependent on the intensity of our focus")
				.font(.title3)
				.fontWeight(.light)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
				.padding()
			
			// MARK: -  FOOTER
			
			Spacer()
			
			Button(action: {
				withAnimation {
					isOnboadingViewActive = true
				}
			}) {
				Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
					.imageScale(.large)
				Text("Restart")
					.font(.system(.title3, design: .rounded))
					.fontWeight(.bold)
			} //: Button
			.buttonStyle(.borderedProminent)
			.buttonBorderShape(.capsule)
			.controlSize(.large)
		} //: VStack
		// Animation Timing
		// 화면이 나타나고 3초 뒤에 animation 시작될 수 있게 main thread 에 접근해서 asyncAfter 를 주어서 3초 delay 를 줍니다
		.onAppear(perform: {
			DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
				isAnimating = true
			})
		})
	}
}

// MARK: -  PREVIEW
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
