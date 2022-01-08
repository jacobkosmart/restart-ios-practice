//
//  OnboardingView.swift
//  Restart
//
//  Created by Jacob Ko on 2022/01/08.
//

import SwiftUI

struct OnboardingView: View {
	// MARK: PROPERTY
	@AppStorage("onboading") var isOnboadingViewActive: Bool = true
	
	@State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
	@State private var buttonOffset: CGFloat = 0
	// property to control the animation
	@State private var isAnimating: Bool = false
	// Drag Gesture imageOffset
	@State private var imageOffset : CGSize = .zero
	@State private var indicatorOpacity: Double = 1.0
	@State private var textTitle: String = "Share."
	
	// Haptic Feedback generator instance
	let hapticFeedback = UINotificationFeedbackGenerator()
	
	// MARK: - BODY
	var body: some View {
		ZStack {
			Color("ColorBlue")
				.ignoresSafeArea(.all, edges: .all)
			
			VStack(spacing: 20) {
				// MARK: -  HEADER
				
				Spacer()
				
				VStack (spacing: 0) {
					Text(textTitle)
						.font(.system(size: 60))
						.fontWeight(.heavy)
						.foregroundColor(.white)
					// Text opacity transition
						.transition(.opacity)
					// Using ID method to tell SwiftUI that a view is No Longer the same view.
						.id(textTitle)
					
					Text("""
					 It's not how much we give but
					 how much love we put into giving.
					 """)
						.font(.title3)
						.fontWeight(.light)
						.foregroundColor(.white)
						.multilineTextAlignment(.center)
						.padding(.horizontal, 10)
				} //: HEADER
				// Header Animating
				.opacity(isAnimating ? 1 : 0)
				// Slide Down (위에서 y 축 -40 에서 0 원래 위치로 이동하는 animation
				.offset(y: isAnimating ? 0 : -40)
				// Animation Parameter: valele parameter 는 iOS15 부터 적용된 필수항목임
				.animation(.easeOut(duration: 1), value: isAnimating)
				
				// MARK: - CENTER
				ZStack {
					// Reusable Components
					CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
					// Parallax Effect
						.offset(x: imageOffset.width * -1) // Opposite Direction
						.blur(radius: abs(imageOffset.width / 5)) // blur: Only positive Number
						.animation(.easeOut(duration: 1), value: imageOffset)
					
					
					Image("character-1")
						.resizable()
						.scaledToFit()
					// Image Animation
						.opacity(isAnimating ? 1 : 0)
						.animation(.easeOut(duration: 2.0), value: isAnimating)
					// Image Gesture
						.offset(x: imageOffset.width * 1.2, y: 0) // Accelerate the movement
					// rotationEffect
					// .degrees: Angle parameter by sepcifying the degree to set how much the image
						.rotationEffect(.degrees(Double(imageOffset.width / 20)))
						.gesture(
							DragGesture()
								.onChanged{ gesture in
									// - 값도 있으니 absolute 절대값으로 150 이하일때만 움직이게 하기
									if abs(imageOffset.width) <= 150 {
										imageOffset = gesture.translation
										// indicator arrow fadeOut
										withAnimation(.linear(duration: 0.25)) {
											indicatorOpacity = 0
											textTitle = "Give."
										}
									}
								}
							// drag 후에 종료 시점 알림
								.onEnded { _ in
									imageOffset = .zero
									// indicator arrow fadeIn
									withAnimation(.linear(duration: 0.25)) {
										indicatorOpacity = 1
										textTitle = "Share."
									}
								}
						) //: GESTURE
						.animation(.easeOut(duration: 1), value: imageOffset)
				} //: CENTER
				// Arrow Indicator
				.overlay(
					Image(systemName: "arrow.left.and.right.circle")
						.font(.system(size: 44, weight: .ultraLight))
						.foregroundColor(.white)
						.offset(y: 20)
						.opacity(isAnimating ? 1: 0)
						.animation(.easeOut(duration: 1).delay(2), value: isAnimating)
						.opacity(indicatorOpacity)
					, alignment: .bottom
				)
				
				Spacer()
				
				// MARK: -  FOOTER
				ZStack {
					// Parts of the custom Button
					
					// 1. Background (Static)
					Capsule()
						.fill(Color.white.opacity(0.2))
					
					Capsule()
						.fill(Color.white.opacity(0.2))
						.padding(8)
					// 2. Call-to-action (Static)
					
					Text("Get Start")
						.font(.system(.title3, design: .rounded))
						.fontWeight(.bold)
						.foregroundColor(.white)
						.offset(x: 20)
					
					// 3. Capsule (Dynamic Width)
					HStack {
						Capsule()
							.fill(Color("ColorRed"))
						// drag 될때
							.frame(width: buttonOffset + 80)
						
						Spacer()
					}
					
					// 4. Circle (Draggable)
					
					HStack {
						ZStack {
							Circle()
								.fill(Color("ColorRed"))
							Circle()
								.fill(.black.opacity(0.15))
								.padding(8)
							Image(systemName: "chevron.right.2")
								.font(.system(size: 24, weight: .bold))
						}
						.foregroundColor(.white)
						.frame(width: 80, height: 80, alignment: .center)
						.offset(x: buttonOffset)
						.gesture(
							DragGesture()
							// onChnage: drag 변경사항설정
								.onChanged{ gesture in
									if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
										buttonOffset = gesture.translation.width
									}
								}
							// drag action 이 끌날때 의 설정값: bottonWidth 값의 절만이 넘어가면 HomeView 로 이동, 절만 이하이면 다시 원위치 시킴
								.onEnded({ _ in
									// transition
									withAnimation(Animation.easeOut(duration: 1.0)) {
										if buttonOffset > buttonWidth / 2 {
											hapticFeedback.notificationOccurred(.success)
											playSound(sound: "chimeup", type: "mp3")
											buttonOffset = buttonWidth - 80
											isOnboadingViewActive = false
										} else {
											hapticFeedback.notificationOccurred(.warning)
											buttonOffset = 0
										}
									}
								})
						) //: GESTURE
						
						Spacer()
					} //: HSTACK
				} //: FOOTER
				.frame(width: buttonWidth, height: 80, alignment: .center)
				.padding()
				// Footer Animation
				.opacity(isAnimating ? 1 : 0)
				.offset(y: isAnimating ? 0 : 40)
				.animation(.easeOut(duration: 1), value: isAnimating)
			} //: Vstack
		} //: ZStack
		// Animation Start (화면 이 시작될때 animation 시작)
		.onAppear(perform: {
			isAnimating = true
		})
		//  Status bar Style : dark mode로 status bar 변경됨
		.preferredColorScheme(.dark)
	}
}

// MARK: -  PREVIEW
struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView()
	}
}

