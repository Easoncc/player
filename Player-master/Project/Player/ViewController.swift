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
import AVFoundation

//let videoUrl = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!
//let videoUrl = URL(string: "http://www.w3school.com.cn/example/html5/mov_bbb.mp4")!

let videoUrl = URL(string: "xxxx://stream7.iqilu.com/10339/upload_transcode/202002/18/20200218114723HDu3hhxqIT.mp4")!
//https://media.w3.org/2010/05/sintel/trailer.mp4
//

//http://www.w3school.com.cn/example/html5/mov_bbb.mp4
//
//https://www.w3schools.com/html/movie.mp4

//http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
//
//http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8
//https://stream7.iqilu.com/10339/upload_transcode/202002/18/20200218114723HDu3hhxqIT.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/18/20200218093206z8V1JuPlpe.mp4
//https://stream7.iqilu.com/10339/article/202002/18/2fca1c77730e54c7b500573c2437003f.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/18/20200218025702PSiVKDB5ap.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/18/202002181038474liyNnnSzz.mp4
//https://stream7.iqilu.com/10339/article/202002/18/02319a81c80afed90d9a2b9dc47f85b9.mp4
//http://stream4.iqilu.com/ksd/video/2020/02/17/c5e02420426d58521a8783e754e9f4e6.mp4
//http://stream4.iqilu.com/ksd/video/2020/02/17/87d03387a05a0e8aa87370fb4c903133.mp4
//https://stream7.iqilu.com/10339/article/202002/17/c292033ef110de9f42d7d539fe0423cf.mp4
//http://stream4.iqilu.com/ksd/video/2020/02/17/97e3c56e283a10546f22204963086f65.mp4
//https://stream7.iqilu.com/10339/article/202002/17/778c5884fa97f460dac8d90493c451de.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/17/20200217021133Eggh6zdlAO.mp4
//https://stream7.iqilu.com/10339/article/202002/17/4417a27b1a656f4779eaa005ecd1a1a0.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/17/20200217104524H4D6lmByOe.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/17/20200217101826WjyFCbUXQ2.mp4
//http://stream.iqilu.com/vod_bag_2016//2020/02/16/903BE158056C44fcA9524B118A5BF230/903BE158056C44fcA9524B118A5BF230_H264_mp4_500K.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/16/20200216050645YIMfjPq5Nw.mp4
//https://stream7.iqilu.com/10339/article/202002/16/3be2e4ef4aa21bfe7493064a7415c34d.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4
//https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209104902N3v5Vpxuvb.mp4

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
        self.view.backgroundColor = UIColor.white
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

//        self.player.playerDelegate = self
//        self.player.playbackDelegate = self
//
//        self.player.playerView.playerBackgroundColor = .black
//        self.view.backgroundColor = UIColor.white
////        self.addChild(self.player)
//        self.player.playerView.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: 200)
//        self.view.addSubview(self.player.playerView)
////        self.player.didMove(toParent: self)
//
////        let localUrl = Bundle.main.url(forResource: "IMG_3267", withExtension: "MOV")
////        self.player.url = localUrl
//        self.player.url = videoUrl
//
//        self.player.playbackLoops = true
//
//        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        self.player.playerView.addGestureRecognizer(tapGestureRecognizer)
        
        let url = URL(string: "xxxx://stream7.iqilu.com/10339/upload_transcode/202002/18/20200218114723HDu3hhxqIT.mp4")!
        print(url.scheme as Any)

        self.view.addSubview(playerView)
        newplayer = AVPlayer()
        let asset = dowload.asset(url: url)
        item = AVPlayerItem.init(asset: asset)
        let layer = AVPlayerLayer.init(player: newplayer)
        layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        playerView.layer.addSublayer(layer)
        newplayer?.replaceCurrentItem(with: item)
        newplayer?.play()
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            self.newplayer?.play()
//        }
//       _ = layer.observe(\.isReadyForDisplay, options: [.new, .old]) { [weak self] (object, change) in
//            self?.newplayer?.play()
//        }
        item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
                // 缓冲进度 暂时不处理
            } else if keyPath == #keyPath(AVPlayerItem.status) {
                // 监听状态改变
                if item?.status == .readyToPlay {
                    // 只有在这个状态下才能播放
                    newplayer?.play()
                } else if item?.status == .failed {
                    print("加载失败")
                } else {
                    print("加载异常")
                }
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    
    var dowload: AssetDowload = AssetDowload()
    var newplayer: AVPlayer?
    var item: AVPlayerItem?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player.playFromBeginning()
    }
    
    lazy var playerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 400, width: self.view.frame.width, height: 200)
        return view
    }()
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
        self.player.takeSnapshot { (image, error) in
            if let _ = image {
                print("image")
            }
            
            if let e = error {
                print("error: \(e)")
            }
        }
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

