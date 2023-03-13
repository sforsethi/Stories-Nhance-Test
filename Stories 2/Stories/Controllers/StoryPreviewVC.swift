//
//  StoryPreviewVC.swift
//  NhanceStories
//
//  Created by ashish painuly on 06/03/23.
//

import UIKit
import AnimatedCollectionViewLayout
import PanModal

class StoryPreviewVC: UIViewController {
    
    private var currentImage: UIImage! {
        didSet {
            guard oldValue != currentImage else { return }
            do {
                
                dominantColors = try currentImage.dominantColorFrequencies()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    private var dominantColors = [ColorFrequency]() {
        didSet {
            previewCV.reloadData()
        }
    }
    
    var storyTimer: Timer? {
        willSet {
          storyTimer?.invalidate()
        }
      }
    
    @IBOutlet weak var previewCV: UICollectionView!
    @IBOutlet weak var progressCV: UICollectionView!
    
    var longPressGestureState: UILongPressGestureRecognizer.State?
    
    let progress = Progress(totalUnitCount: 10)
    
//    private lazy var longPress_gesture: UILongPressGestureRecognizer = {
//        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
//        lp.minimumPressDuration = 0.2
//        lp.delegate = self
//        return lp
//    }()
    
    var storyIndex:Int = 0
    var totalStoryIndex:Int = 1
    var imageArr:[String] = []
    
    var darkColorArr:[UIColor] = []
    var lightColorArr:[UIColor] = []
    
    var isLikeButtonTapped = false
    var isPaused: Bool = false
    var isMoreOptionTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewCV?.isPagingEnabled = true

        let layout = AnimatedCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.animator = CubeAttributesAnimator()
        previewCV.collectionViewLayout = layout
        
        
        previewCV.register(UINib(nibName: "StoryPreviewCollecionCell", bundle: nil), forCellWithReuseIdentifier: "StoryPreviewCollecionCell")
        
        progressCV.register(UINib(nibName: "StoryDetailCollecionCell", bundle: nil), forCellWithReuseIdentifier: "StoryProgressCollecionCell")
        
        var localImageArr:[String] = []
        
        for i in 0..<totalStoryIndex{
            if i == 0{
                localImageArr.append("dog")
            }else if i == 1{
                localImageArr.append("Baby gift pack")
            }else if i == 2{
                localImageArr.append("IMG_5706")
            }else if i == 3{
                localImageArr.append("IMG_5986")
            }else if i == 4{
                localImageArr.append("ocean")
            }else if i == 5{
                localImageArr.append("ocean-story")
            }else if i == 6{
                localImageArr.append("dog")
            }else{
                localImageArr.append("IMG_5986")
            }
            
        }
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "someLabel")
        let sema = DispatchSemaphore(value: 0)
//        queue.async {
//            for (i,item) in localImageArr.enumerated(){
//                group.enter()
//                let img = UIImageView()
//                img.image = UIImage(named: item)
//                print("item:\(item)")
//                Palette.generateWith(configuration: PaletteConfiguration(image: img.image!)) {
//                    // group.enter()
//                    if let color = $0.darkMutedSwatch?.color {
//                        //self.backgroundColor = color
//                        self.darkColorArr.append(color)
//                    }
//                    
//                    if let color = $0.lightVibrantSwatch?.color {
//                        //self.textLabel.textColor = color
//                        self.lightColorArr.append(color)
//                    }
//                    print("index")
//                    group.leave()
//                    sema.signal()
//                    if i == localImageArr.count - 1{
//                        self.startStoryProgress()
//                        self.progressCV.reloadData()
//                        self.previewCV.reloadData()
//                    }
//                }
//                sema.wait()
//            }
//        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        //group.notify(queue: queue) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.startStoryProgress(direction: "right")
            }
            self.imageArr = localImageArr
      //  }
        let currImg = imageArr[0]
        let img = UIImageView()
        img.image = UIImage(named: currImg)
        print("item:\(currImg)")
        self.currentImage = img.image!
        self.progressCV.reloadData()
        self.previewCV.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isMoreOptionTapped {
            callStoryTimer()
            isPaused = false
            isMoreOptionTapped = false
        }
    }

    @IBAction func cancelBtnTap(_ sender: Any) {
        backVC()
    }
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressGestureState = sender.state
    }
    
    func backVC(){
        self.dismiss(animated: true)
    }
    
    @objc func openMoreOptionsPopup(_ sender: UIButton) {
        print("BUTTON PRESSED")
        isMoreOptionTapped = true
        storyTimer?.invalidate()
        storyTimer = nil
        isPaused = true
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoryOptionsBottomVC") as! StoryOptionsBottomVC
        self.presentPanModal(vc)
    }
    
    @objc func likeButtonTap(_ sender: UIButton) {
        print("LIKE STORY", sender.tag)
        isLikeButtonTapped = !isLikeButtonTapped
        if isLikeButtonTapped == true {
            sender.setImage(UIImage(named: "ic-heart-filled"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic-heart-unfilled"), for: .normal)
        }
    }
    
    @objc func shareButtonTap(_ sender: UIButton) {
        print("SHARE STORY")
        storyTimer?.invalidate()
        storyTimer = nil
        isPaused = true
        let shareStr = "Share Your Story"
        let activityViewController = UIActivityViewController(activityItems: [shareStr], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self.callStoryTimer()
            self.isPaused = false
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer)
      {
        if let location = sender.location(in: self.view) as? CGPoint{
        // let touch = touches.first
        // if let location = touches.location(in: UIScreen.main.focusedView) {
          let halfScreenWidth = UIScreen.main.bounds.width / 2
          if location.x < halfScreenWidth {
            print("Left touch")
            if self.storyIndex >= 0{
              if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
                self.progress.completedUnitCount = 0
                cell.progressView.progress = 0
                //cell.progressView.setProgress(0, animated: true)
              }
              self.storyIndex = self.storyIndex - 1
              storyTimer?.invalidate()
              storyTimer = nil
              if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
                self.progress.completedUnitCount = 0
                cell.progressView.progress = 0
                if self.imageArr.count > self.storyIndex{
                  if self.storyIndex >= 0{
                    guard let currentImage = self.imageArr[self.storyIndex] as? String else {
                      fatalError("Could not find image.")
                    }
                    let img = UIImageView()
                    img.image = UIImage(named: currentImage)
                    print("item:\(currentImage)")
                    self.currentImage = img.image!
                  }
                }
                let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
                //get current content Offset of the Collection view
                let contentOffset = self.previewCV.contentOffset;
                self.previewCV.scrollRectToVisible(CGRectMake(contentOffset.x - cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
                // self.callStoryTimer()
                //cell.progressView.setProgress(0, animated: true)
              }
              self.startStoryProgress(direction: "left")
              // previousPageTransition()
            }
            //Your actions when you click on the left side of the screen
          } else {
            print("Right touch")
            storyTimer?.invalidate()
            storyTimer = nil
            if self.imageArr.count > storyIndex{
              if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
                self.progress.completedUnitCount = 10
                cell.progressView.progress = 10
              }
              self.storyIndex = self.storyIndex + 1
              if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
                self.progress.completedUnitCount = 0
                cell.progressView.progress = 0
                // cell.progressView.setProgress(0, animated: true)
                let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
                //get current content Offset of the Collection view
                let contentOffset = self.previewCV.contentOffset;
                self.previewCV.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
              }
              self.startStoryProgress(direction: "right")
            }
            //storyTransition()
            // Your actions when you click on the right side of the screen
          }
        }
      }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
      {
        if sender.state == .ended {
          callStoryTimer()
          isPaused = false
              //return
        }else if sender.state == .began {
          storyTimer?.invalidate()
          storyTimer = nil
          isPaused = true
        }
      }
}

extension StoryPreviewVC {
//    func startStoryProgress(){
//        self.progress.completedUnitCount = 0
//        if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
//            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
//                guard self.progress.isFinished == false else{
//                    timer.invalidate()
//                    print("Finished")
//                    self.storyIndex = self.storyIndex + 1
//                    if self.storyIndex == self.imageArr.count{
//                        self.backVC()
//                    }else{
//                        //get cell size
//                        let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
//
//                        //get current content Offset of the Collection view
//                        let contentOffset = self.previewCV.contentOffset;
//
//                        let numberOfPages = self.imageArr.count
//                        let currentPage = Int(self.previewCV.contentOffset.x / (self.previewCV.contentSize.width / CGFloat(numberOfPages)))
//                        guard let currentImage = self.imageArr[self.storyIndex] as? String else {
//                            fatalError("Could not find image.")
//                        }
//                        let img = UIImageView()
//                        img.image = UIImage(named: currentImage)
//                        print("item:\(currentImage)")
//                        self.currentImage = img.image!
//
//
//                        //scroll to next cell
//                        UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: { [weak self]() -> Void in
//
//                            // self.previewCV.scrollToItem(at: IndexPath(row: self.storyIndex, section: 0), at: .centeredHorizontally, animated: true)
//                        }) { [weak self](finished) -> Void in
//                            self?.previewCV.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
//                            self?.startStoryProgress()
//                    }
//
//
//                    }
//                    return
//                }
//
//                self.progress.completedUnitCount += 1
//
//                let progressFloat = Float(self.progress.fractionCompleted)
//                cell.progressView.setProgress(progressFloat, animated: true)
//            }
//        }
//    }
    
    func startStoryProgress(direction:String){
        self.progress.completedUnitCount = 0
        if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
          cell.progressView.setProgress(0, animated: true)
          callStoryTimer()
        }
      }
    
    @objc func storyStartsTimerFunc() {
        // storyTimer.invalidate()
    //      self.storyTimer?.invalidate()
        if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
          guard self.progress.isFinished == false else{
            //self.storyTimer?.invalidate()
            print("Finished")
            self.storyTimer = nil
            self.storyTimer?.invalidate()
            //      if direction == "left"{
            //        self.storyIndex = self.storyIndex - 1
            //      }else{
                    self.storyIndex = self.storyIndex + 1
            //      }
            if self.storyIndex == self.imageArr.count{
              self.backVC()
            }else{
              if self.imageArr.count > self.storyIndex{
                let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
                //get current content Offset of the Collection view
                let contentOffset = self.previewCV.contentOffset;
                let numberOfPages = self.imageArr.count
                let currentPage = Int(self.previewCV.contentOffset.x / (self.previewCV.contentSize.width / CGFloat(numberOfPages)))
                if self.imageArr.count > self.storyIndex{
                  if self.storyIndex >= 0{
                    guard let currentImage = self.imageArr[self.storyIndex] as? String else {
                      fatalError("Could not find image.")
                    }
                    let img = UIImageView()
                    img.image = UIImage(named: currentImage)
                    print("item:\(currentImage)")
                    self.currentImage = img.image!
                    //scroll to next cell
                    UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: { [weak self]() -> Void in
                    }) { [weak self](finished) -> Void in
                      //                  if direction == "left"{
                      //                    self?.previewCV.scrollToItem(at: IndexPath(row: self?.storyIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
                      //
                      //                  }else{
                      self?.previewCV.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
                      self?.startStoryProgress(direction: "right")
                      //self?.storyStartsTimerFunc()
                      //}
                    }
                  }
                }
              }
            }
            return
          }
            //self.storyTransition()
            self.progress.completedUnitCount += 1
          print("Story index:\(self.storyIndex)")
            let progressFloat = Float(self.progress.fractionCompleted)
            cell.progressView.setProgress(progressFloat, animated: true)
          }
          return
        }
    
    func callStoryTimer(){
        if self.storyTimer == nil{
          storyTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(storyStartsTimerFunc), userInfo: nil, repeats: true)
        }
      }
}
extension StoryPreviewVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 101{
            return imageArr.count
        }
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 101{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryProgressCollecionCell", for: indexPath) as! StoryProgressCollecionCell
            
            //cell.backgroundColor = UIColor.clear
            //cell.contentView.backgroundColor = .clear
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryPreviewCollecionCell", for: indexPath) as! StoryPreviewCollecionCell
            cell.isUserInteractionEnabled = true
//            previewCV.addGestureRecognizer(longPress_gesture)
            
            //cell.backgroundColor = UIColor.clear
            //cell.contentView.backgroundColor = .clear
            
            cell.previewImgView.image = UIImage(named: imageArr[indexPath.row])
            let getAverageColor = cell.previewImgView.image?.averageColor2
            
            cell.topGradientIV.backgroundColor = getAverageColor
            
            let arraySlice = dominantColors.suffix(3)
            let newArray = Array(arraySlice)
            if newArray.count > 0{
                cell.bottomGradientIV.backgroundColor =  newArray[1].color
            }else{
                cell.bottomGradientIV.backgroundColor = getAverageColor
            }
            cell.storyLikeButton.tag = indexPath.row
            cell.storyShareButton.tag = indexPath.row
            cell.moreOptionButton.tag = indexPath.row
            cell.storyLikeButton.addTarget(self, action: #selector(likeButtonTap(_:)), for: .touchUpInside)
            cell.storyShareButton.addTarget(self, action: #selector(shareButtonTap(_:)), for: .touchUpInside)
            cell.moreOptionButton.addTarget(self, action: #selector(openMoreOptionsPopup(_:)), for: .touchUpInside)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
                  cell.contentView.addGestureRecognizer(tapGestureRecognizer)
                  let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
                  cell.contentView.addGestureRecognizer(longPressRecognizer)
            
            return cell
        }
    }
}

extension StoryPreviewVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 101{
            return CGSize(width: (Int(UIScreen.main.bounds.width) / imageArr.count) - 5, height: 10)
        }
       
        return CGSize(width: Int(UIScreen.main.bounds.width) , height: Int(UIScreen.main.bounds.height))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 101{
            return 5
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 101{
            return 5
        }
        return 0
    }
}



extension StoryPreviewVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer is UISwipeGestureRecognizer) {
            return true
        }
        return false
    }
}

extension StoryPreviewVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !(scrollView is UITableView) else { return }
        let numberOfPages = imageArr.count
        let currentPage = Int(scrollView.contentOffset.x / (scrollView.contentSize.width / CGFloat(numberOfPages)))
        guard let currentImage = imageArr[currentPage] as? String else {
            fatalError("Could not find image.")
        }
        let img = UIImageView()
        img.image = UIImage(named: currentImage)
        print("item:\(currentImage)")
        self.currentImage = img.image!
       
    }
    
}
