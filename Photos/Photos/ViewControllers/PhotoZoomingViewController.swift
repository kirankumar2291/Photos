//
//  PhotoZoomingViewController.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit

class PhotoZoomingViewController: UIViewController {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    var arrPhotos = [Photos]()
    var currentImageView = UIImageView()
    var currentIndex = -1
    var isFromRecentlyDeleted = false
    var isPhotoFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromRecentlyDeleted == true
        {
            bottomViewHeightConstraint.constant = 0
        }
        else
        {
            bottomViewHeightConstraint.constant = 50
        }
        
        scrlView.maximumZoomScale = 10.0
        scrlView.minimumZoomScale = 1.0
        scrlView.zoomScale = 1.0
        scrlView.backgroundColor = UIColor.black
        scrlView.isPagingEnabled = true
        scrlView.bounces = false
        bindData()
        let photo = arrPhotos[currentIndex]
        isPhotoFavorite = CoreDataAccessLayer.isPhotoFavorite(photo: photo)
        favoriteButton.isSelected = isPhotoFavorite
        // Do any additional setup after loading the view.
    }

    func bindData()
    {
        var count = 0
        var xPos = 0
        while count < arrPhotos.count {
            let subScroll = UIScrollView(frame: CGRect(x: xPos, y: 0, width: Int(self.view.frame.size.width), height: Int(scrlView.frame.size.height - 50)))
            subScroll.maximumZoomScale = 10.0
            subScroll.minimumZoomScale = 1.0
            subScroll.zoomScale = 1.0
            subScroll.delegate = self
            subScroll.bounces = false
            
            let imgTile = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: subScroll.frame.size.height))
            imgTile.backgroundColor = UIColor.clear
            imgTile.contentMode = .scaleAspectFit
            imgTile.isUserInteractionEnabled = true
            imgTile.tag = xPos + 1
            let photo = arrPhotos[count]
            let imageName = String(format: "%@.jpg", photo.imageName!)
            imgTile.image = UIImage(contentsOfFile: GlobalMethods.getImageForName(name: imageName))
            
            subScroll.contentSize = imgTile.bounds.size
            subScroll.addSubview(imgTile)
            scrlView.addSubview(subScroll)
            xPos = xPos + Int(self.view.frame.size.width)
            if currentIndex == count
            {
                currentImageView = imgTile
            }
            count = count + 1

        }
        
        scrlView.contentSize = CGSize(width: xPos, height: Int(scrlView.frame.size.height))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        var arrItemsToShare = [UIImage]()
        arrItemsToShare.append(currentImageView.image!)
        let control = UIActivityViewController(activityItems: arrItemsToShare, applicationActivities: nil)
        control.popoverPresentationController?.sourceView = self.view
        self.present(control, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        let photo = arrPhotos[currentIndex]
        if sender.isSelected == true
        {
            CoreDataAccessLayer.favoritePhoto(photo: photo)
        }
        else
        {
            CoreDataAccessLayer.unFavoritePhoto(photo: photo)
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "", message: "This photo will also be deleted from an album.", preferredStyle: .actionSheet)
        let deleteString = "Delete Photo"
        let deleteButton = UIAlertAction(title: deleteString, style: .default) { (action) in
            var arrItemsToDelete = [Photos]()
            let photo = self.arrPhotos[self.currentIndex]

            arrItemsToDelete.append(photo)
            CoreDataAccessLayer.deleteMultiplePhotos(arrPhotos: arrItemsToDelete)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)

    }
}

extension PhotoZoomingViewController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xPos = scrollView.contentOffset.x
        let index = xPos/self.view.frame.size.width
        currentIndex = Int(index)
        if let imgView = scrollView.viewWithTag(Int(xPos + 1)) as? UIImageView
        {
            currentImageView = imgView
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != scrlView
        {
            for view in scrollView.subviews
            {
                if view.isKind(of: UIImageView.self)
                {
                    return view
                }
            }
        }
        return nil
    }
}
