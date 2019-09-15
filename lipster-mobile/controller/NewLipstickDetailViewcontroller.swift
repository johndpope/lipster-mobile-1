//
//  CustomViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero
import MXSegmentedControl

class NewLipstickDetailViewcontroller: UIViewController {

    @IBOutlet weak var segmentedControl3: MXSegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var tryMeButton: UIButton!
    @IBOutlet weak var scrollLipstickImages: UIScrollView!
    @IBOutlet weak var lipstickImagesPageControl: UIPageControl!
    
    
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
 
    
    @IBOutlet weak var lipstickSelectColorCollectionView: UICollectionView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
  
    var isFav = UserDefaults.standard.bool(forKey: "isFav")
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let reviewDataPipe = Signal<[UserReview], NoError>.pipe()
    var reviewDataObserver: Signal<[UserReview], NoError>.Observer?
    
    let colorDataPipe = Signal<[Lipstick], NoError>.pipe()
    var colorDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    var reviews: [UserReview] = [UserReview]()
    var lipstick : Lipstick?
    var colors: [Lipstick] = [Lipstick]()
    var imageHeroId = String()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(">>>>self.lipstick>>>>>> \(self.lipstick)")
        
        initHero()
        initReactiveData()
        fetchData()
        initialUI()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.titleNavigationItem.title = lipstick?.lipstickBrand
     
        segmentedControl3.append(title: "Description").set(title: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) , for: .selected)
        segmentedControl3.append(title: "Ingredient").set(title: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .selected)

      //  segmentedControl3.indicator.boxView.alpha = 0.1
        
        segmentedControl3.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
       
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        if isFav == true {
            let image = UIImage(named: "heart_white")
            sender.setImage(image, for: UIControl.State.normal)
        } else {
            let image = UIImage(named: "heart_red")
            sender.setImage(image, for: UIControl.State.normal)
        }
        
        isFav = !isFav
        UserDefaults.standard.set(isFav, forKey: "isFav")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func clickedTryMe(_ sender: Any) {
        self.performSegue(withIdentifier: "showTryMe", sender: self)
    }
    
    @IBAction func clickedSeeReviews(_ sender: Any) {
        self.performSegue(withIdentifier: "showReview", sender: self)
    }
    @objc func changeIndex(segmentedControl: MXSegmentedControl) {
        
        if let segment = segmentedControl.segment(at: segmentedControl.selectedIndex) {
            segmentedControl.indicator.boxView.backgroundColor = segment.titleColor(for: .selected)
            segmentedControl.indicator.lineView.backgroundColor = segment.titleColor(for: .selected)
        }
    }
    
}

// MARK: fetch data
extension NewLipstickDetailViewcontroller {
    func fetchData() {
        
       // fetchLipstickSameDetail()
    }
   
//    func fetchLipstickSameDetail() {
//        LipstickRepository.fetchLipstickWithSameDetail(lipstick: self.lipstick!) { (lipsticks) in
//            self.colorDataPipe.input.send(value: lipsticks)
//        }
//    }
}


// Init UI
extension NewLipstickDetailViewcontroller: UIScrollViewDelegate {
    func initialUI() {
        if let lipstick = self.lipstick{
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
          //  self.lipstickShortDetail.text = lipstick.lipstickDetail
        }
       
        pageController()
    }
    
    func pageController() {
        lipstickImagesPageControl.numberOfPages = self.lipstick?.lipstickImage.count ?? 0
        
        for index in 0..<lipstickImagesPageControl.numberOfPages {
            frame.origin.x = scrollLipstickImages.frame.size.width * CGFloat(index)
            frame.size = scrollLipstickImages.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: self.lipstick!.lipstickImage[index]), placeholderImage: UIImage(named: "nopic"))
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            self.scrollLipstickImages.addSubview(imgView)
        }
        if self.lipstick?.lipstickImage.count == 0 {
            let imgView = UIImageView(frame: frame)
            lipstickImagesPageControl.numberOfPages = 1
            
            lipstick?.lipstickImage.append("")
            imgView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "nopic"))
            self.scrollLipstickImages.addSubview(imgView)
        }
        
        scrollLipstickImages.contentSize = CGSize(
            width: (scrollLipstickImages.frame.size.width *  CGFloat(lipstickImagesPageControl.numberOfPages)),
            height: scrollLipstickImages.frame.size.height)
        scrollLipstickImages.delegate = self
        //contentScrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollLipstickImages {
            lipstickImagesPageControl.currentPage = scrollView.currentPage()
        } else {
//            if scrollView == contentScrollView {
//            contentSegmentControl.selectedSegmentIndex = scrollView.currentPage()
//
        }
    }
}

// collectionView cell
extension NewLipstickDetailViewcontroller : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectColorFromDetailCollectionViewCell", for: indexPath) as? SelectColorFromDetailCollectionViewCell
        
        cell?.selectColorView.backgroundColor = colors[indexPath.item].lipstickColor
        if colors[indexPath.item].lipstickId == lipstick?.lipstickId {
            cell?.triangleView.isHidden = false
        } else {
            cell?.triangleView.isHidden = true
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lipstick = colors[indexPath.item]
        initialUI()
        collectionView.reloadData()
       
    }
    
}

extension NewLipstickDetailViewcontroller{
    func initReactiveData() {
//        reviewDataObserver = Signal<[UserReview], NoError>.Observer(value: { (userReviews) in
//            self.reviews = userReviews
//            self.reviewTableView.reloadData()
//            self.reviewTableView.setNeedsLayout()
//        })
//        reviewDataPipe.output.observe(reviewDataObserver!)
//        
        colorDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipstickColors) in
            self.colors = lipstickColors
            self.lipstickSelectColorCollectionView.reloadData()
            self.lipstickSelectColorCollectionView.setNeedsLayout()
        })
        colorDataPipe.output.observe(colorDataObserver!)
    }
    
}

extension NewLipstickDetailViewcontroller {
    func initHero() {
        self.hero.isEnabled = true
        self.scrollLipstickImages.hero.id = imageHeroId
    }
}


