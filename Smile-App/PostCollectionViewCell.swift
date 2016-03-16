//
//  PostCollectionViewCell.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import AVFoundation
import UIKit

protocol LogInProtocol {
    
    func showLogInVC()
    
}

class PostCollecionViewCell: UICollectionViewCell {
    
    let numberFormatter: NSNumberFormatter = {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
        
        }()
    
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var mediaURL: NSURL?
    var subView: UIView!
    var avPlayer: AVPlayer!
    
    var post: Post!
    var postStore: PostStore!
    var mediaStore = MediaStore()
    var scoreStore: ScoreStore!
    
    var delegate: LogInProtocol!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        updateWithPost(post)
        
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        updateWithPost(post)
        
    }
    
    func updateWithPost(post: Post?) {
        
        println("Update With Post")
        
        playButton.hidden = true
        
        if let player = avPlayer {
            
            stopPlaymedia(player)
            
        }
        
        if (subView != nil) {
            
            subView .removeFromSuperview()
            
        }

        if let currentPost = post {
            
            captionLabel.text = currentPost.caption
            let votesDic = currentPost.votes
            let votesCount = votesDic["count"] as Int
            votesLabel.text = "\(numberFormatter.stringFromNumber(votesCount)!) Votes"
            let commentsDic = currentPost.comments
            let commentsCount = commentsDic["count"] as Int
            commentsLabel.text = "\(numberFormatter.stringFromNumber(commentsCount)!) Comments"
            
            if let imageToDisplay = currentPost.image {

                spinner.stopAnimating()
                imageView.image = imageToDisplay
                
                if let dicMediaURL = currentPost.mediaLinks {
                    
                    let mediaURLString = dicMediaURL["mp4"] as String
                    mediaURL = NSURL(string: mediaURLString)
                    avPlayer = AVPlayer(URL: mediaURL)
                    playButton.hidden = false
                    
                }
                
            } else {
                
                spinner.startAnimating()
                imageView.image = nil
                
            }
            
            if let store = scoreStore {
             
                println(scoreStore.scoreForKey(currentPost.id))
                
                switch scoreStore.scoreForKey(currentPost.id) {
                    
                case -1:
                    likeButton.titleLabel?.textColor = UIColor.whiteColor()
                    dislikeButton.titleLabel?.textColor = UIColor.blueColor()
                    
                case 1:
                    likeButton.titleLabel?.textColor = UIColor.blueColor()
                    dislikeButton.titleLabel?.textColor = UIColor.whiteColor()
                    
                default:
                    likeButton.titleLabel?.textColor = UIColor.whiteColor()
                    dislikeButton.titleLabel?.textColor = UIColor.whiteColor()
                    
                }
                
            }
            
        } else {
            
            spinner.startAnimating()
            imageView.image = nil
            
        }
        
    }
    
    func playMedia(url: NSURL) {

        if ((avPlayer.rate != 0) && (avPlayer.error == nil)) {
            
            // player is playing
            stopPlaymedia(avPlayer)

        } else {
            
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)
            subView = UIView(frame: imageView.frame)
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
            subView = nil
            
        }
        
    }
    
    @IBAction func likeClicked(sender: AnyObject) {
        
        if let isLogged = AppDelegate.sharedInstance.isLogged {
            
            postStore.voteForPost(post, type: Type.Like, token: AppDelegate.sharedInstance.access_token!, completion: { (voteResult) -> Void in
                
                switch voteResult {
                    
                case let VoteResult.Success(votes):
                    
                    let score = votes["score"] as? Int
                    self.scoreStore.setScore(score!, forKey: self.post.id)
                    
                case let VoteResult.Failure(error):
                    
                    println(error.description)
                    
                }
                
            })
            
            updateWithPost(post)
            
        } else {

            delegate.showLogInVC()
            
        }
        
    }
    
    @IBAction func dislikeClicked(sender: AnyObject) {
        
        
    }
    
    @IBAction func commentClicked(sender: AnyObject) {
        
        
        
    }
    
}
