//
//  NScrollViewLoop.swift
//  ScrollViewLoopSwift
//
//  Created by Nero Zuo on 15/7/31.
//  Copyright (c) 2015年 Nero Zuo. All rights reserved.
//

import UIKit

class NScrollViewLoop: UIScrollView {
    private var timer :NSTimer?
    private var pageControl: UIPageControl?
    var isAutoSlip: Bool = true
    var period: NSTimeInterval = 3.0
    var pageIndicatorTintColor = UIColor.grayColor()
    var currentPageIndicatorTintColor = UIColor.blackColor()
    var didSelectItem: ((index: Int) -> ())?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
        self.hidden = true
        pagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        if(isAutoSlip){
            timer?.invalidate()
            timer = NSTimer(timeInterval: period, target: self, selector: Selector("slipPictures"), userInfo: nil, repeats: true)
            
        }
        hidden = false
    }
    
    func layoutViewInScoreViewWithImages(imageModels: [NScrollImageModel]) {
         self.contentSize = CGSize(width: self.frame.size.width * ( CGFloat(imageModels.count) + 2.0), height: self.frame.size.height)
        for (index, imageModel) in enumerate(imageModels) {
            if let image = imageModel.image {
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: CGFloat(index + 1)*self.frame.size.width, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
                imageView.tag = index
                imageView.userInteractionEnabled = true
                self.addSubview(imageView)
                let tap = UITapGestureRecognizer(target: self, action:Selector("didTapImage:"))
                imageView.addGestureRecognizer(tap)
            }
        }
        if let firstImage = imageModels.first!.image {
            let imageView = UIImageView(image: firstImage)
            imageView.frame = CGRectMake(CGFloat(imageModels.count + 1) * self.frame.size.width, 0.0, self.frame.size.width, self.frame.size.height)
            self.addSubview(imageView)
        }
        if let lastImage = imageModels.last!.image {
            let imageView = UIImageView(image: lastImage)
            imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
            self.addSubview(imageView)
        }
        self.setContentOffset(CGPoint(x: self.frame.size.width, y: 0.0), animated: false)
        
        pageControl = UIPageControl(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height - 22.0, width: self.frame.size.width, height: 22.0));
        pageControl!.numberOfPages = imageModels.count
        pageControl!.currentPage = 0
        pageControl!.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl!.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.superview?.addSubview(pageControl!)
    }
    
    func slipPictures() {
        UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.contentOffset = CGPoint(x: CGFloat(self.pageControl!.currentPage + 2) * self.frame.size.width, y: 0.0)
            }, completion: { finished in
                if finished {
                    let page = floor((self.contentOffset.x - self.frame.size.width/2)/self.frame.size.width) + 1
                    let totalPage = floor(self.contentSize.width / self.frame.size.width)
                    if self.pageControl!.currentPage == Int(totalPage) - 3 {
                        self.setContentOffset(CGPoint(x: self.frame.size.width, y: 0.0), animated: false)
                        self.pageControl!.currentPage = 0
                        return
                    }
                    self.pageControl!.currentPage++
                }
        })
    }
  
    func didTapImage(tap: UITapGestureRecognizer){
        didSelectItem?(index: tap.view!.tag)
    }
    
    

}

extension NScrollViewLoop :UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(isAutoSlip) {
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(period, target: self, selector: Selector("slipPictures"), userInfo: nil, repeats: true)
        }
        
        let page = floor((scrollView.contentOffset.x - scrollView.frame.size.width/2)/scrollView.frame.size.width) + 1
        let totalPages = floor(scrollView.contentSize.width / scrollView.frame.size.width)
        if Int(page) == 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(totalPages - 2), y: 0.0), animated: false)
            pageControl!.currentPage = Int(totalPages) - 1
            return
        }
        
        if Int(page) == (Int(totalPages)-1) {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0.0), animated: false)
            pageControl!.currentPage = 0
            return
        }
        pageControl!.currentPage = Int(page) - 1
    }
}