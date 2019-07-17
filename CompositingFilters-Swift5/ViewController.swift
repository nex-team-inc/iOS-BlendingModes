//
//  ViewController.swift
//  CompositingFilters-Swift5
//
//  Created by Austin Kwong on 7/16/19.
//  Copyright © 2019 Austin Kwong. All rights reserved.
//

// Copy from https://github.com/arthurschiller/CompositingFilters/blob/master/CompositingFilters/ViewController.swift
import AVFoundation
import UIKit

class ViewController: UIViewController {

    // MARK: View Outlets
    @IBOutlet weak var object1: UIView!
    @IBOutlet weak var object2: UIView!
    @IBOutlet weak var selectedCompositeFilterLabel: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var compositeFilterPickerView: UIPickerView!
    private let assetUrl = Bundle.main.url(forResource: "7B00BF88-F57B-4E65-B1C6-94A982AC7FD8-0", withExtension: "mov")
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: Constraint Outlets
    @IBOutlet weak var pickerContainerViewBottomConstraint: NSLayoutConstraint!

    // MARK: Properties
    let compositingFilterStrings = [
        "normalBlendMode",
        //
        "darkenBlendMode",
        "multiplyBlendMode",
        "colorBurnBlendMode",
        //
        "lightenBlendMode",
        "screenBlendMode",
        "colorDodgeBlendMode",
        //
        "overlayBlendMode",
        "softLightBlendMode",
        "hardLightBlendMode",
        //
        "differenceBlendMode",
        "exclusionBlendMode",
        //
        /*
         "hueBlendMode",
         "saturationBlendMode",
         "colorBlendMode",
         "luminosityBlendMode",
         */
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        togglePickerContainerView(show: false, animated: false)
        setCompositeFilter(index: 0)
        setupVideoBackground()
    }

    func setCompositeFilter(index: Int) {

        let filterString = compositingFilterStrings[index]
        print(filterString)

        object1.layer.compositingFilter = filterString
        object2.layer.compositingFilter = filterString
        selectedCompositeFilterLabel.text = "Selected Filter: »\(filterString)«"
    }

    func togglePickerContainerView(show: Bool, animated: Bool) {

        if animated {
            UIView.animate(withDuration: show ? 0.6 : 0.7, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.55, options: [], animations: {

                self.pickerContainerView.alpha = show ? 1 : 0
                self.pickerContainerViewBottomConstraint.constant = show ? 0 : -self.pickerContainerView.bounds.height
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            pickerContainerView.alpha = show ? 1 : 0
            pickerContainerViewBottomConstraint.constant = show ? 0 : -pickerContainerView.bounds.height
        }
    }

    override func viewDidLayoutSubviews() {
        playerLayer?.frame = UIScreen.main.bounds
        self.view.bringSubviewToFront(object2)
        self.view.bringSubviewToFront(object1)
        object1.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        object2.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }

    private func setupVideoBackground() {
        guard let url = assetUrl else { return }

        self.player = AVPlayer(url: url)

        guard let player = player else { return }
        let playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer = playerLayer
        playerLayer.frame = UIScreen.main.bounds
        if let lastLayer = view.layer.sublayers?.last {
            self.view.layer.insertSublayer(playerLayer, below: lastLayer)
        } else {
            self.view.layer.addSublayer(playerLayer)
        }
        self.player?.play()

        // Loop Video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
}

extension ViewController {

    // MARK: Handler for button taps
    @IBAction func openPickerViewButtonWasPressed(_ sender: Any) {
        togglePickerContainerView(show: true, animated: true)
    }

    @IBAction func closePickerViewButtonWasPressed(_ sender: Any) {
        togglePickerContainerView(show: false, animated: true)
    }

    // MARK: Handler for gesture recognizers
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }

    @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }

    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        if let view = recognizer.view {
            self.view.bringSubviewToFront(view)
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return compositingFilterStrings.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return compositingFilterStrings[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        setCompositeFilter(index: row)
    }

}
