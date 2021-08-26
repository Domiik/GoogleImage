//
//  ImageViewController.swift
//  GoogleImage
//
//  Created by Domiik on 25.08.2021.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController {
    
    public var imageName: String!
    var lastPoint = CGPoint.zero
    var swiped = false
    var brushWidth: CGFloat = 10.0
    var color = UIColor.black
    var opacity: CGFloat = 1.0
    var notScroll = false
    var i = 0
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageName)
        imageView.kf.setImage(with: url)
        // Do any additional setup after loading the view.
//        scrollView.maximumZoomScale = 4
//        scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
        
        
        
    }
    
    @IBAction func onOffDraw(_ sender: Any) {
        i += 1
        if i % 2 == 0 {
            scrollView.isUserInteractionEnabled = false
            scrollView.isScrollEnabled = false
            notScroll = true
        } else {
            scrollView.isUserInteractionEnabled =  true
            scrollView.isScrollEnabled = true
            notScroll = false
        }
       
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        
        UIGraphicsEndImageContext()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
}


//extension ImageViewController: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        print("viewzooming")
//        return imageView
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        if notScroll {
//            print("zooming")
//        if scrollView.zoomScale > 1 {
//            print("zooming")
//            if let image = imageView.image {
//                let ratioW = imageView.frame.width / image.size.width
//                let ratioH = imageView.frame.height / image.size.height
//
//                let ratio = ratioW < ratioH ? ratioW : ratioH
//                let newWidth = image.size.width * ratio
//                let newHight = image.size.height * ratio
//
//                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
//
//                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
//
//                let conditionTop = newHight * scrollView.zoomScale > imageView.frame.height
//
//                let top = 0.5 * (conditionTop ? newHight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
//
//                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
//            } else {
//                scrollView.contentInset = .zero
//                print("zooming")
//            }
//        }
//        }
//    }
//}
