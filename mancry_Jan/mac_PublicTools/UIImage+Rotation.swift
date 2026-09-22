import UIKit

extension UIImage {
    
    func mancry_rotateLeftDegreesImg() -> UIImage? {
/// rotate image
/// left
        let mancry_width = self.size.width
        let mancry_height = self.size.height
///size
        ///
        UIGraphicsBeginImageContextWithOptions(CGSize(width: mancry_height, height: mancry_width), false, self.scale)
        
        guard let mancry_context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        mancry_context.translateBy(x: mancry_height / 2, y: mancry_width / 2)
        mancry_context.rotate(by: -.pi / 2)
        self.draw(in: CGRect(x: -mancry_width / 2, y: -mancry_height / 2, width: mancry_width, height: mancry_height))
        let mancry_rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mancry_rotatedImage
    }
    
    /// 水平翻转图片（左右镜像），不改变图片尺寸和 scale
    func flippedHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 在水平轴上做镜像：先平移，再按 X 轴缩放 -1
        context.translateBy(x: size.width, y: 0)
        context.scaleBy(x: -1.0, y: 1.0)
        
        draw(in: CGRect(origin: .zero, size: size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
}
