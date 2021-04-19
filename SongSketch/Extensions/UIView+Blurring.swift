//
//  UIView+Blurring.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/18/21.
//

import UIKit

//Got this from here: https://stackoverflow.com/a/56521521/13663074


public extension UIView {
    
    func applyBlur(level: CGFloat, view: UIView) {
    let context = CIContext(options: nil)
    self.makeBlurredImage(with: level, context: context, completed: { processedImage in
      let imageView = UIImageView(image: processedImage)
      imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
//      self.addSubview(imageView)
      NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: self.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      ])
    })
  }

  private func makeBlurredImage(with level: CGFloat, context: CIContext, completed: @escaping (UIImage) -> Void) {
    // screen shot
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 1)
    self.layer.render(in: UIGraphicsGetCurrentContext()!)
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    let beginImage = CIImage(image: resultImage)

    // make blur
    let blurFilter = CIFilter(name: "CIGaussianBlur")!
    blurFilter.setValue(beginImage, forKey: kCIInputImageKey)
    blurFilter.setValue(level, forKey: kCIInputRadiusKey)

    // extend source image na apply blur to it
    let cropFilter = CIFilter(name: "CICrop")!
    cropFilter.setValue(blurFilter.outputImage, forKey: kCIInputImageKey)
    cropFilter.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

    let output = cropFilter.outputImage
    var cgimg: CGImage?
    var extent: CGRect?

    let global = DispatchQueue.global(qos: .userInteractive)

    global.async {
      extent = output!.extent
      cgimg = context.createCGImage(output!, from: extent!)!
      let processedImage = UIImage(cgImage: cgimg!)

      DispatchQueue.main.async {
        completed(processedImage)
      }
    }
  }
}
