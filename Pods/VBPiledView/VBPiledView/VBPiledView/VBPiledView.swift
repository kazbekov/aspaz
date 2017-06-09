//
//  VBPiledView.swift
//  VBPiledView
//
//  Created by Viktor Braun (v-braun@live.de) on 02.07.16.
//  Copyright © 2016 dev-things. All rights reserved.
//


public protocol VBPiledViewDataSource{
    func piledView(numberOfItemsForPiledView: VBPiledView) -> Int
    func piledView(viewForPiledView: VBPiledView, itemAtIndex index: Int) -> UIView
}

public class VBPiledView: UIView, UIScrollViewDelegate {
    let tapGesture = UITapGestureRecognizer()
    private let _scrollview = UIScrollView()
    public var dataSource : VBPiledViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initInternal();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initInternal();
    }
    
    override public func layoutSubviews() {
        _scrollview.frame = self.bounds
        
        self.layoutContent()
        
        super.layoutSubviews()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutContent()
    }
    
    private func initInternal(){
        _scrollview.showsVerticalScrollIndicator = true
        _scrollview.showsHorizontalScrollIndicator = false
        _scrollview.isScrollEnabled = true
        _scrollview.delegate = self
        
        tapGesture.addTarget(self, action: #selector(viewTapped))
        self.addSubview(_scrollview)
    }
    
    public var expandedContentHeightInPercent : Float = 80
    public var collapsedContentHeightInPercent : Float = 5
    
    func viewTapped() {
        print("asd")
    }
    
    private func layoutContent(){
        guard let data = dataSource else {return}
        
        
        
        let currentScrollPoint = CGPoint(x:0, y: _scrollview.contentOffset.y)
        let contentMinHeight = (CGFloat(collapsedContentHeightInPercent) * _scrollview.bounds.height) / 100
        let contentMaxHeight = (CGFloat(expandedContentHeightInPercent) * _scrollview.bounds.height) / 100
        
        var lastElementH = CGFloat(0)
        var lastElementY = currentScrollPoint.y
        
        let subViewNumber = data.piledView(numberOfItemsForPiledView: self)
        _scrollview.contentSize = CGSize(width: self.bounds.width, height: _scrollview.bounds.height * CGFloat(subViewNumber))
        for index in 0..<subViewNumber {
            let v = data.piledView(viewForPiledView: self, itemAtIndex: index)
            
            if !v.isDescendant(of: _scrollview){
                v.addGestureRecognizer(tapGesture)
                _scrollview.addSubview(v)
            }
            
            let y = lastElementY + lastElementH
            let currentViewUntransformedLocation = CGPoint(x: 0, y: (CGFloat(index) * _scrollview.bounds.height) + _scrollview.bounds.height)
            let prevViewUntransformedLocation = CGPoint(x: 0, y: currentViewUntransformedLocation.y - _scrollview.bounds.height)
            let slidingWindow = CGRect(origin: currentScrollPoint, size: _scrollview.bounds.size)
            
            var h = contentMinHeight
            if index == subViewNumber-1 {
                h = _scrollview.bounds.size.height
                if(currentScrollPoint.y > CGFloat(index) * _scrollview.bounds.size.height){
                    h = h + (currentScrollPoint.y - CGFloat(index) * _scrollview.bounds.size.height)
                }
            }
            else if slidingWindow.contains(currentViewUntransformedLocation){
                let relativeScrollPos = currentScrollPoint.y - (CGFloat(index) * _scrollview.bounds.size.height)
                let scaleFactor = (relativeScrollPos * 100) / _scrollview.bounds.size.height
                let diff = (scaleFactor * contentMaxHeight) / 100
                h = contentMaxHeight - diff
            }
            else if slidingWindow.contains(prevViewUntransformedLocation){
                h = contentMaxHeight - lastElementH
                if currentScrollPoint.y < 0 {
                    h = h + abs(currentScrollPoint.y)
                }
                else if(h < contentMinHeight){
                    h = contentMinHeight
                }
            }
            else if slidingWindow.origin.y > currentViewUntransformedLocation.y {
                h = 0
            }
            
            v.frame = CGRect(origin: CGPoint(x: 0, y: y), size: CGSize(width: _scrollview.bounds.width, height: h))
            
            lastElementH = v.frame.size.height
            lastElementY = v.frame.origin.y
        }
    }
    
}

