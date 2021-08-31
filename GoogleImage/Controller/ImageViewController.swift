//
//  ImageViewController.swift
//  GoogleImage
//
//  Created by Domiik on 25.08.2021.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController {
    
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    private var initialCenter: CGPoint = .zero
    
    public var imageName: String!
    var lastPoint = CGPoint.zero
    var swiped = false
    var brushWidth: CGFloat = 10.0
    var color = UIColor.black
    var opacity: CGFloat = 1.0
    var notScroll = false
    var i = 0
    var myView: DrawCircles!
    
    private let pannableView: UIView = {
        // Initialize View
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: 70, height: 70)))
        
        // Configure View
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageName)
        imageView.kf.setImage(with: url)
        
        pannableView.center = imageView.center

        myView = DrawCircles(frame: CGRect(x: imageView.center.x, y: imageView.center.y, width: 70, height: 70))
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pannableView.isUserInteractionEnabled = true
        myView.addGestureRecognizer(panGestureRecognizer)
        // Do any additional setup after loading the view.
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
    }
    
    
    @IBAction func drawCircle(_ sender: Any) {
        
        imageView.addSubview(myView)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        imageView.bringSubviewToFront(myView)
        let translation = sender.translation(in: self.imageView)
        myView.center = CGPoint(x: myView.center.x + translation.x , y: myView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.imageView)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}


extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //print("viewzooming")
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if notScroll {
           // print("zooming")
        if scrollView.zoomScale > 1 {
            //print("zooming")
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height

                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHight = image.size.height * ratio

                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width

                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))

                let conditionTop = newHight * scrollView.zoomScale > imageView.frame.height

                let top = 0.5 * (conditionTop ? newHight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            } else {
                scrollView.contentInset = .zero
               // print("zooming")
            }
        }
        }
    }
}
