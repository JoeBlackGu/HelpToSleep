//
//  SleepViewController.swift
//  HelpToSleep
//
//  Created by Joe on 31/01/2017.
//  Copyright © 2017 Joe. All rights reserved.
//

import UIKit
import AVFoundation
@IBDesignable

class SleepViewController: UIViewController, UIScrollViewDelegate, AVAudioPlayerDelegate {
    
    private var scrollView: UIScrollView!
    
    private lazy var viewHeight: CGFloat = self.view.frame.size.height
    private lazy var viewWidth: CGFloat = self.view.frame.size.width
    
    private var rainScene: UIView!
    private var forestScene: UIView!
    private var groceryScene: UIView!
    
    private var btnstart: UIButton!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
    }
    
    
    //create scroll view
    private func setScrollView() {
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: viewWidth * 3, height: viewHeight)
        
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        rainScene = addScene("rain", atPoint: 0.0)
        forestScene = addScene("forest", atPoint: viewWidth)
        groceryScene = addScene("grocery", atPoint: viewWidth * 2)
        
        scrollView.addSubview(rainScene)
        scrollView.addSubview(forestScene)
        scrollView.addSubview(groceryScene)
        
        self.view.addSubview(scrollView)
        
    }
    
    
    let viewColor = [
        "rain": UIColor(patternImage: #imageLiteral(resourceName: "rain")),
        "grocery": UIColor(patternImage: #imageLiteral(resourceName: "grocery")),
        "forest": UIColor(patternImage: #imageLiteral(resourceName: "forest")),
        "pause": UIColor.gray
    ]
    
    var isPlaying = false
    
    func addScene(_ scene: String, atPoint locationX: CGFloat) -> UIView{
        let sceneView = UIView(frame: CGRect(x: locationX, y: 0.0, width: viewWidth, height: viewHeight))
        sceneView.backgroundColor = viewColor["pause"]
        
        
        let sceneTag: UILabel = UILabel(frame: CGRect(origin: CGPoint(x: sceneView.bounds.midX - 100, y: sceneView.bounds.minY), size: CGSize(width: CGFloat(200), height: CGFloat(100))))
        sceneTag.text = scene
        sceneTag.textAlignment = NSTextAlignment.center
        sceneTag.textColor = UIColor.black
        sceneTag.font = UIFont.systemFont(ofSize: 40)
        
        sceneView.addSubview(sceneTag)
        sceneView.bringSubview(toFront: sceneTag)
        
        return sceneView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if (offset == CGFloat(0.0)) || (offset == viewWidth) || (offset == viewWidth * 2) {
            update()
        }
    }
    
    
    @IBAction func changeState(_ sender: UITapGestureRecognizer) {
        isPlaying = !isPlaying
        update()

        
    }
    
    private func getSceneTitle() -> String {
        let offset = scrollView.contentOffset.x
        if offset < viewWidth {
            return "rain"
        } else if offset < viewWidth * 2 {
            return "forest"
        } else {
            return "grocery"
        }
    }
    
    private func update() {
        if isPlaying == false {
            setBackgroundColorToPause()
    
            if player != nil {
                player.pause()
            }
        } else if isPlaying == true {
            resetBackgroundColor()
            
            let  currentScene = getSceneTitle()
            setPlayer(currentScene)
            player.play()
            
            Timer.scheduledTimer(
                timeInterval: playDuration,
                target: self,
                selector: #selector(timerStop),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    private func setBackgroundColorToPause() {
        rainScene.backgroundColor = viewColor["pause"]
        forestScene.backgroundColor = viewColor["pause"]
        groceryScene.backgroundColor = viewColor["pause"]
        
    }
    
    private func resetBackgroundColor() {
        rainScene.backgroundColor = viewColor["rain"]
        forestScene.backgroundColor = viewColor["forest"]
        groceryScene.backgroundColor = viewColor["grocery"]
    }
    
    //player
    private var player: AVAudioPlayer!
  
    
    private func setPlayer(_ witScene: String) {
            let path = Bundle.main.path(forResource: witScene, ofType: "wav")
            
            let url = URL(fileURLWithPath: path!)
            
            player = try? AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
            player.prepareToPlay()
    }
    
    //timer
    
    private var playDuration = 1800.0
    private var timeLeft = 0.0
    
    
    func timerStop() {
        player.pause()
        setBackgroundColorToPause()
        isPlaying = false
    }
    
    
}


























