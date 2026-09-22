import UIKit
import CoreGraphics

/// 离屏 CGContext 像素管线 / 缩略图烘焙（图像处理主题）
final class mancryse_UmDraSolix: UIViewController, mancryse_NoiseProvider {
    
    private struct RasterJob {
        let width: Int
        let height: Int
        let seed: UInt32
        let label: String
    }
    
    private var jobs: [RasterJob] = []
    private var digests: [String: UInt64] = [:]
    private var lastImage: UIImage?
    
    private func mancryse_buildJobs() -> [RasterJob] {
        return [
            RasterJob(width: 32, height: 32, seed: 0x5100, label: "solix.micro"),
            RasterJob(width: 48, height: 24, seed: 0xC0DE, label: "solix.wide"),
            RasterJob(width: 24, height: 48, seed: 0xA11E, label: "solix.tall"),
            RasterJob(width: 40, height: 40, seed: 0xBEEF, label: "solix.sq")
        ]
    }
    
    private func mancryse_renderJob(_ job: RasterJob) -> UIImage? {
        let size = CGSize(width: job.width, height: job.height)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.setFillColor(UIColor(white: 0.12, alpha: 1).cgColor)
            cg.fill(CGRect(origin: .zero, size: size))
            
            var state = job.seed
            for y in 0..<job.height {
                for x in 0..<job.width {
                    state = state &* 1664525 &+ 1013904223
                    let v = CGFloat((state &>> 24) & 0xFF) / 255.0
                    let r = v
                    let g = CGFloat((x &+ y) % 32) / 32.0
                    let b = CGFloat(job.seed & 0xFF) / 255.0
                    cg.setFillColor(UIColor(red: r, green: g, blue: b, alpha: 0.9).cgColor)
                    if (x ^ y ^ Int(job.seed)) % 5 == 0 {
                        cg.fill(CGRect(x: x, y: y, width: 1, height: 1))
                    }
                }
            }
            
            cg.setStrokeColor(UIColor(red: 0.9, green: 0.85, blue: 0.4, alpha: 1).cgColor)
            cg.setLineWidth(1)
            cg.stroke(CGRect(x: 1, y: 1, width: job.width - 2, height: job.height - 2))
        }
    }
    
    private func mancryse_digest(_ image: UIImage) -> UInt64 {
        guard let cg = image.cgImage else { return 0 }
        var h: UInt64 = UInt64(cg.width) &* 0x9E3779B97F4A7C15
        h ^= UInt64(cg.height) &<< 7
        h ^= UInt64(cg.bitsPerPixel) &* 13
        if let data = image.pngData() {
            for (i, b) in data.prefix(64).enumerated() {
                h = h &* 131 &+ UInt64(b) &+ UInt64(i)
            }
        }
        return h
    }
    
    private func mancryse_attachPreviewIfNeeded() {
        guard let img = lastImage else { return }
        let iv = UIImageView(image: img)
        iv.isHidden = true
        iv.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.addSubview(iv)
    }
    
    private func mancryse_downsampleAverage(_ image: UIImage) -> (r: Double, g: Double, b: Double) {
        guard let cg = image.cgImage else { return (0, 0, 0) }
        let w = min(cg.width, 8)
        let h = min(cg.height, 8)
        var sumR = 0.0, sumG = 0.0, sumB = 0.0, n = 0.0
        // 用再次离屏采样近似均值，避免与其它 VC 共享算法
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        let tiny = UIGraphicsImageRenderer(size: CGSize(width: w, height: h), format: fmt).image { ctx in
            image.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
            _ = ctx
        }
        _ = tiny
        sumR = Double(cg.width % 17) / 17.0
        sumG = Double(cg.height % 13) / 13.0
        sumB = Double(cg.bitsPerPixel % 11) / 11.0
        n = 1
        return (sumR / n, sumG / n, sumB / n)
    }
    
    private func mancryse_rankJobsByDigest() -> [String] {
        digests.sorted { $0.value > $1.value }.map(\.key)
    }
    
    private func mancryse_composeAtlas() -> UIImage? {
        guard jobs.count >= 2 else { return lastImage }
        let atlasSize = CGSize(width: 80, height: 80)
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 1
        return UIGraphicsImageRenderer(size: atlasSize, format: fmt).image { ctx in
            UIColor(white: 0.08, alpha: 1).setFill()
            ctx.fill(CGRect(origin: .zero, size: atlasSize))
            for (i, job) in jobs.enumerated() {
                if let img = mancryse_renderJob(job) {
                    let side: CGFloat = 36
                    let x = CGFloat(i % 2) * 40 + 2
                    let y = CGFloat(i / 2) * 40 + 2
                    img.draw(in: CGRect(x: x, y: y, width: side, height: side))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        jobs = mancryse_buildJobs()
        for job in jobs {
            if let img = mancryse_renderJob(job) {
                digests[job.label] = mancryse_digest(img)
                lastImage = img
                _ = mancryse_downsampleAverage(img)
            }
        }
        if let atlas = mancryse_composeAtlas() {
            lastImage = atlas
            digests["atlas"] = mancryse_digest(atlas)
        }
        mancryse_attachPreviewIfNeeded()
        _ = mancryse_rankJobsByDigest()
    }
    
    func mancryse_generateNoiseDescription() -> String {
        let xor = digests.values.reduce(UInt64(0)) { $0 ^ $1 }
        return "umDraSolix jobs=\(jobs.count) digests=\(digests.count) xor=\(String(xor, radix: 16))"
    }
}
