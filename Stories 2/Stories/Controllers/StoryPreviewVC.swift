//
//  StoryPreviewVC.swift
//  NhanceStories
//
//  Created by ashish painuly on 06/03/23.
//

import UIKit
import AnimatedCollectionViewLayout
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
    @IBOutlet weak var previewCV: UICollectionView!
    @IBOutlet weak var progressCV: UICollectionView!
    
    var longPressGestureState: UILongPressGestureRecognizer.State?
    
    let progress = Progress(totalUnitCount: 10)
    
    private lazy var longPress_gesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        lp.minimumPressDuration = 0.2
        lp.delegate = self
        return lp
    }()
    
    var storyIndex:Int = 0
    var totalStoryIndex:Int = 1
    var imageArr:[String] = []
    
    var darkColorArr:[UIColor] = []
    var lightColorArr:[UIColor] = []
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
                self.startStoryProgress()
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

    @IBAction func cancelBtnTap(_ sender: Any) {
        backVC()
    }
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressGestureState = sender.state
    }
    
    func backVC(){
        self.dismiss(animated: true)
    }
}

extension StoryPreviewVC{
    func startStoryProgress(){
        self.progress.completedUnitCount = 0
        if let cell = progressCV.cellForItem(at: IndexPath(row: storyIndex, section: 0)) as? StoryProgressCollecionCell{
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                guard self.progress.isFinished == false else{
                    timer.invalidate()
                    print("Finished")
                    self.storyIndex = self.storyIndex + 1
                    if self.storyIndex == self.imageArr.count{
                        self.backVC()
                    }else{
                        //get cell size
                        let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
                        
                        //get current content Offset of the Collection view
                        let contentOffset = self.previewCV.contentOffset;
                        
                        
                        let numberOfPages = self.imageArr.count
                        let currentPage = Int(self.previewCV.contentOffset.x / (self.previewCV.contentSize.width / CGFloat(numberOfPages)))
                        guard let currentImage = self.imageArr[self.storyIndex] as? String else {
                            fatalError("Could not find image.")
                        }
                        let img = UIImageView()
                        img.image = UIImage(named: currentImage)
                        print("item:\(currentImage)")
                        self.currentImage = img.image!
                        
                        
                        //scroll to next cell
                        UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: { [weak self]() -> Void in
                            
                            // self.previewCV.scrollToItem(at: IndexPath(row: self.storyIndex, section: 0), at: .centeredHorizontally, animated: true)
                        }) { [weak self](finished) -> Void in
                            self?.previewCV.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
                            self?.startStoryProgress()
                    }
                       
                        
                    }
                    return
                }
                
                self.progress.completedUnitCount += 1
                
                let progressFloat = Float(self.progress.fractionCompleted)
                cell.progressView.setProgress(progressFloat, animated: true)
            }
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
            previewCV.addGestureRecognizer(longPress_gesture)
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
