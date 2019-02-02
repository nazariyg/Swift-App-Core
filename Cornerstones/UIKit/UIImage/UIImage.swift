// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public extension UIImage {

    func tinted(withColor color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: rect)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    static func pixelImage(withColor color: UIColor) -> UIImage {
        let pixelImage = solidImage(withColor: color, size: CGSize(width: 1, height: 1))
        return pixelImage
    }

    static func solidImage(withColor color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

    func croppedImage(inRect cropRect: CGRect) -> UIImage {
        let scaledCropRect =
            CGRect(
                x: cropRect.origin.x*scale,
                y: cropRect.origin.y*scale,
                width: cropRect.size.width*scale,
                height: cropRect.size.height*scale)
        if let cgCroppedImage = cgImage?.cropping(to: scaledCropRect) {
            let croppedImage = UIImage(cgImage: cgCroppedImage, scale: scale, orientation: imageOrientation)
            return croppedImage
        } else {
            return self
        }
    }

    /// Resizes the image to a new size using the highest interpolation quality and keeping the rendering mode intact.
    func resized(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.interpolationQuality = .high
        draw(in: CGRect(origin: .zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if var newImage = newImage {
            if renderingMode != .automatic {
                newImage = newImage.withRenderingMode(renderingMode)
            }
            return newImage
        } else {
            return self
        }
    }

    func resized(withScale resizeScale: CGFloat) -> UIImage {
        let newSize = CGSize(width: size.width*resizeScale, height: size.height*resizeScale)
        return resized(newSize: newSize)
    }

    func normalized() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let normalizedImage = normalizedImage {
            return normalizedImage
        } else {
            return self
        }
    }

}
