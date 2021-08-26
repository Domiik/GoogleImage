//
//  ImageDrawViewController.swift
//  GoogleImage
//
//  Created by Domiik on 26.08.2021.
//

import UIKit
import Kingfisher

class ImageDrawViewController: UIViewController {
    
    var imageScrollView: ImageScrollView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    public var imageName: String!
    var lastPoint = CGPoint.zero
    var swiped = false
    var brushWidth: CGFloat = 10.0
    var color = UIColor.black
    var opacity: CGFloat = 1.0
    var notScroll = false
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()
        imageScrollView.isUserInteractionEnabled = false
       
        let image = UIImage(named: "Model_2")!
        
        
        self.imageScrollView.set(image: image)
        // Do any additional setup after loading the view.
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    @IBAction func onOffDraw(_ sender: Any) {
        print("click")
        i += 1
        if i % 2 == 0 {
           
        } else {
          
        }
       
    }

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
        UIGraphicsBeginImageContext(imageScrollView.frame.size)
        imageScrollView.imageZoomView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        imageScrollView.imageZoomView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }

}
