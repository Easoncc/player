//  ViewController.swift
//
//  Created by patrick piemonte on 11/26/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-present patrick piemonte (http://patrickpiemonte.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

//let videoUrl = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!
//let videoUrl = URL(string: "http://www.w3school.com.cn/example/html5/mov_bbb.mp4")!

let videoUrl = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
//https://media.w3.org/2010/05/sintel/trailer.mp4
//
//http://www.w3school.com.cn/example/html5/mov_bbb.mp4
//
//https://www.w3schools.com/html/movie.mp4
//
//http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
//
//http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8


class ViewController: UIViewController {

    fileprivate var player = Player()
    
    // MARK: object lifecycle
    deinit {
//        self.player.willMove(toParent: nil)
//        self.player.view.removeFromSuperview()
//        self.player.removeFromParent()
        self.player.playerView.removeFromSuperview()
    }

    // MARK: view lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        
        self.player.playerView.playerBackgroundColor = .black
        
//        self.addChild(self.player)
        self.player.playerView.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 200)
        self.view.addSubview(self.player.playerView)
//        self.player.didMove(toParent: self)
        
//        let localUrl = Bundle.main.url(forResource: "IMG_3267", withExtension: "MOV")
//        self.player.url = localUrl
        self.player.url = videoUrl
        
        self.player.playbackLoops = true
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.playerView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player.playFromBeginning()
    }
}

// MARK: - UIGestureRecognizer

extension ViewController {
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch self.player.playbackState {
        case .stopped:
            self.player.playFromBeginning()
            break
        case .paused:
            self.player.playFromCurrentTime()
            break
        case .playing:
            self.player.pause()
            break
        case .failed:
            self.player.pause()
            break
        }
    }
    
}

// MARK: - PlayerDelegate

extension ViewController: PlayerDelegate {
    
    func playerReady(_ player: Player) {
        print("\(#function) ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("\(#function) \(player.playbackState.description)")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        print(bufferTime)
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("\(#function) error.description")
    }
    
}

// MARK: - PlayerPlaybackDelegate

extension ViewController: PlayerPlaybackDelegate {
    
    func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
    }

    func playerPlaybackDidLoop(_ player: Player) {
    }
}
