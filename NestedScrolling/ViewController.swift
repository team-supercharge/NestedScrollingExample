//
//  ViewController.swift
//  NestedScrolling
//
//  Created by Csaba Vidó on 2019. 07. 25..
//  Copyright © 2019. Csaba Vidó. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet private weak var containterScrollView: MyScrollView!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var tableView: MyTableView!
    @IBOutlet private weak var button: UIButton!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        button.rx.tap.subscribe(onNext: { _ in
            UIApplication.shared.open(URL(string: "https://supercharge.io")!)
        }).disposed(by: bag)

        cardView.layer.cornerRadius = 40
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = .init(width: 0, height: -2)
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.rasterizationScale = UIScreen.main.scale

        containterScrollView.contentInset = .init(top: 100, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let items = Observable.just(["AppKit",
                                     "Bundle Resources",
                                     "Foundation",
                                     "Swift",
                                     "SwiftUI",
                                     "TVML",
                                     "TVMLKit",
                                     "TVMLKit JS",
                                     "TVUIKit",
                                     "UIKit",
                                     "WatchKit",
                                     "Graphics and Games",
                                     "AGL",
                                     "ARKit",
                                     "ColorSync",
                                     "Core Animation",
                                     "Core Graphics",
                                     "Core Image",
                                     "Game Controller",
                                     "GameKit",
                                     "GameplayKit",
                                     "GLKit",
                                     "Image I/O",
                                     "Metal",
                                     "Metal Performance Shaders",
                                     "MetalKit",
                                     "Model I/O",
                                     "OpenGL ES",
                                     "PDFKit",
                                     "PencilKit",
                                     "Quartz",
                                     "RealityKit",
                                     "ReplayKit",
                                     "SceneKit",
                                     "SpriteKit",
                                     "Vision"])

        items.bind(to:
            tableView.rx.items(cellIdentifier: "Cell",
                               cellType: UITableViewCell.self)) { _, element, cell in
                                cell.textLabel?.text = element
            }.disposed(by: bag)

        containterScrollView.rx.didScroll
            .filter { [unowned self] _ in self.containterScrollView.contentOffset.y <= CGFloat(0.0) }
            .filter { [unowned self] _ in self.tableView.isTracking }
            .map { [unowned self] _ in self.tableView.lastContentOffset }
            .bind(to: tableView.rx.contentOffset)
            .disposed(by: bag)

        tableView.rx
            .setDelegate(tableView)
            .disposed(by: bag)
    }
}

final class MyScrollView: UIScrollView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInits()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInits()
    }

    private func customInits() {
        bounces = false
        scrollsToTop = false
        showsVerticalScrollIndicator = false
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.first?.hitTest(point, with: nil) != nil
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

final class MyTableView: UITableView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var lastContentOffset: CGPoint = .zero

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = contentOffset
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastContentOffset = contentOffset
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        lastContentOffset = contentOffset
    }
}
