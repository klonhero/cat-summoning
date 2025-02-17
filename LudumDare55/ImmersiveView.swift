import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    
    @StateObject var realityKitSceneController: SweeperRealityController = SweeperRealityController()

    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        RealityView { content, attachments in
            await realityKitSceneController.firstInit(&content, attachments: attachments, catType: viewModel.catType)
        } update: { content, attachments in
            realityKitSceneController.updateView(&content, attachments: attachments)
        } placeholder: {
            ProgressView()
        } attachments: {
            let _ = print("--attachments")
            Attachment(id: "score") {
                let goodScore = forTrailingZero(realityKitSceneController.score)
                Text("\(goodScore)")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
        .gesture(SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded({ targetValue in
                realityKitSceneController.onTapSpatial(targetValue)
            })
        )
        .onAppear {
            // appear happens before realitykit scene controller init
        }
        .onDisappear {
            realityKitSceneController.cleanup()
        }
    }

    func forTrailingZero(_ temp: Double) -> String {
        var tempVar = String(format: "%g", temp)
        return tempVar
    }
}
