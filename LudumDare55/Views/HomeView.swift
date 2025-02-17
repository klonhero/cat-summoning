//
//  File.swift
//  LudumDare55
//
//  Created by Nikita Sabynin on 13.04.2024.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: AppViewModel

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @State private var isShowingAboutView = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        NavigationStack {
            VStack {
                CenteredTitle("Summon a Cat!")
                    .padding(.vertical, 10)
                Spacer()

                VStack {
                     CatTypeSelection(viewModel: viewModel)
                     PlayButton(showImmersiveSpace: $showImmersiveSpace)
                     AboutButton {
                         isShowingAboutView = true
                     }
                 }
                 .padding(.bottom, 20)
                 .frame(maxHeight: 540)

                Spacer()

            }
            .navigationDestination(isPresented: $isShowingAboutView) {
                AboutView()
            }
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    HomeView(viewModel: AppViewModel())
//}
