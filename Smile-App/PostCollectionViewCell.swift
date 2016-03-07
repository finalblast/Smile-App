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
                    if subView != nil {
                        
                        subView .removeFromSuperview()
                        
                    }
                    
                } else {
                    
                    playButton.hidden = true
                    if subView != nil {
                        
                        subView .removeFromSuperview()
                        
                    }
                    
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            
            let downloadedData = NSData(contentsOfURL: url)
            if (downloadedData != nil) {
                
                self.mediaStore.setMedia(downloadedData!, forKey: url.path!)
                
            }
            
        })
        
        if (avPlayer.rate == 0.0) {
            println("Play gif")
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)
            subView = UIView(frame: imageFrame)
            subView.layer .addSublayer(avPlayerLayer)
            contentView.addSubview(subView)
            
            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            avPlayer.play()
            
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause;
            
        } else {
            println("Pause gif")
            playButton.hidden = false
            avPlayer.pause()
            
        }
        
    }
    
}
