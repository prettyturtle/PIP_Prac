//
//  ViewController.swift
//  PIP_Prac
//
//  Created by yc on 12/13/23.
//

import UIKit
import AVKit

final class ViewController: UIViewController {
    
    private lazy var playerLayer = AVPlayerLayer()
    private lazy var player = AVPlayer()
    private var pipController: AVPictureInPictureController?
    
    private lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("활성화", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(
            self,
            action: #selector(tapButton),
            for: .touchUpInside
        )
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPip()
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    private func setPip() {
        guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
        
        let asset = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: asset)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        player.play()
        
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }
    
    @objc func tapButton() {
        guard let isActive = pipController?.isPictureInPictureActive else { return }
        isActive ? pipController?.stopPictureInPicture() : pipController?.startPictureInPicture()
        isActive ? button.setTitle("비활성화", for: .normal) : button.setTitle("활성화", for: .normal)
    }
}

extension ViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStart")
    }
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStart")
    }
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("error")
    }
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStop")
    }
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStop")
    }
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("restore")
    }
}
