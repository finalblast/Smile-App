//
//  PostCollectionViewCell.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import AVFoundation
import UIKit

class PostCollecionViewCell: UICollectionViewCell {
    
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var mediaURL: NSURL?
    var imageFrame: CGRect!
    var subView: UIView!
    var avPlayer: AVPlayer!
    
    var mediaStore = MediaStore()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        updateWithPost(nil)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        updateWithPost(nil)
        
    }
    
    func updateWithPost(post: Post?) {
        
        playButton.hidden = true
        
        if let player = avPlayer {
            
            player.pause()
            
        }
        
        if let view = subView {
            
            view .removeFromSuperview()
            
        }

        if let currentPost = post {
            
            captionLabel.text = currentPost.caption
            
            if let imageToDisplay = currentPost.image {

                spinner.stopAnimating()
                imageView.image = imageToDisplay
                imageFrame = imageView.frame
                
                if let dicMediaURL = currentPost.mediaLinks {
                    
                    let mediaURLString = dicMediaURL["mp4"] as String
                    mediaURL = NSURL(string: mediaURLString)
                    playButton.hidden = false
                    
                }
                
            } else {
                
                spinner.startAnimating()
                imageView.image = nil
                
            }
            
        } else {
            
            spinner.startAnimating()
            imageView.image = nil
            
        }
        
    }
    
    func playMedia(url: NSURL) {
        
        
        avPlayer = AVPlayer(URL: url)
        
        if ((avPlayer.rate != 0) && (avPlayer.error == nil)) {
            
            // player is playing
            stopPlaymedia(avPlayer)

        } else {
            
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)
            subView = UIView(frame: imageFrame)
            subView.layer .addSublayer(avPlayerLayer)
            contentView.addSubview(subView)
            
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            avPlayer.play()
            
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None;
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
            
        }
        
    }
    
    func playerDidReachEnd(notification: NSNotification) {
    
        let p = notification.object as AVPlayerItem
        p.seekToTime(kCMTimeZero)
    
    }
    
    func stopPlaymedia(player: AVPlayer) {
        
        if ((player.rate != 0) && (player.error == nil)) {
        
            player.pause()
        
        }
        
        if (subView != nil) {
            
            subView .removeFromSuperview()
            
        }
        
    }
    
}
