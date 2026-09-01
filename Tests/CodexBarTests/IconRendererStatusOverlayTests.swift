import AppKit
import Testing
@testable import CodexBar

struct IconRendererStatusOverlayTests {
    @Test
    func `minor status badge attaches to the prominent single quota meter`() throws {
        func render(_ indicator: ProviderStatusIndicator) throws -> NSBitmapImageRep {
            let image = IconRenderer.makeIcon(
                primaryRemaining: 100,
                weeklyRemaining: nil,
                creditsRemaining: nil,
                stale: false,
                style: .codex,
                statusIndicator: indicator,
                hideCritters: true,
                quotaLayoutPolicy: .provider(.codex))
            return try #require(image.representations.compactMap { $0 as? NSBitmapImageRep }.first {
                $0.pixelsWide == 36 && $0.pixelsHigh == 36
            })
        }

        let plainRep = try render(.none)
        let markedRep = try render(.minor)
        var cutoutPixels = 0
        for y in 0..<markedRep.pixelsHigh {
            for x in 0..<markedRep.pixelsWide {
                let plainAlpha = (plainRep.colorAt(x: x, y: y) ?? .clear).alphaComponent
                let markedAlpha = (markedRep.colorAt(x: x, y: y) ?? .clear).alphaComponent
                if plainAlpha > 0.5, markedAlpha < 0.05 {
                    cutoutPixels += 1
                }
            }
        }

        #expect(cutoutPixels >= 8, "Expected the status badge halo to attach to the single meter")
    }
}
