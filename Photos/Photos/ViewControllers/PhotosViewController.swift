//
//  PhotosViewController.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    var arrSelectedIndexPaths = [IndexPath]()
    var isSelectionModeEnabled = false
    var arrPhotos = [Photos]()
    
    @IBOutlet weak var labelNoItems: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabButtonShare: UITabBarItem!
    
    @IBOutlet weak var tabButtonDelete: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        let rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        collectionViewPhotos.register(UINib(nibName: "PhotoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PHOTOCELL")
        
        reloadData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData()
    {
        self.navigationItem.rightBarButtonItem?.title = "Select"
        if CoreDataAccessLayer.getAllPhotos() != nil
        {
            arrPhotos = CoreDataAccessLayer.getAllPhotos()!
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            arrPhotos.removeAll()
        }
        arrSelectedIndexPaths.removeAll()
        isSelectionModeEnabled = false
        tabButtonShare.isEnabled = false
        tabButtonDelete.isEnabled = false
        
        if arrPhotos.count > 0
        {
            collectionViewPhotos.isHidden = false
            labelNoItems.isHidden = true
            collectionViewPhotos.reloadData()
        }
        else
        {
            collectionViewPhotos.isHidden = true
            labelNoItems.isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectButtonClicked(sender: UIBarButtonItem)
    {
        if sender.title?.caseInsensitiveCompare("Select") == .orderedSame
        {
            sender.title = "Cancel"
            isSelectionModeEnabled = true
        }
        else
        {
            sender.title = "Select"
            reloadData()
        }
    }
    
    func performDeletionOfPhotos()
    {
        let actionSheet = UIAlertController(title: "", message: "Some photos will also be deleted from an album.", preferredStyle: .actionSheet)
        var deleteString = String(format: "Delete %i Photos", arrSelectedIndexPaths.count)
        if arrSelectedIndexPaths.count == 1
        {
            deleteString.removeLast()
        }
        let deleteButton = UIAlertAction(title: deleteString, style: .default) { (action) in
            var arrItemsToDelete = [Photos]()
            for index in self.arrSelectedIndexPaths
            {
                arrItemsToDelete.append(self.arrPhotos[index.item])
            }
            CoreDataAccessLayer.deleteMultiplePhotos(arrPhotos: arrItemsToDelete)
            self.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func performSharingOfPhotos()
    {
        var arrItemsToShare = [UIImage]()
        for index in arrSelectedIndexPaths
        {
            if let cell = collectionViewPhotos.cellForItem(at: index) as? PhotoCollectionViewCell
            {
                arrItemsToShare.append(cell.imageViewTile.image!)
            }
        }
        let control = UIActivityViewController(activityItems: arrItemsToShare, applicationActivities: nil)
        control.popoverPresentationController?.sourceView = self.view
        self.present(control, animated: true, completion: nil)
    }
}

extension PhotosViewController: UITabBarDelegate
{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1000
        {
            performSharingOfPhotos()
        }
        else if item.tag == 1001
        {
            performDeletionOfPhotos()
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if isSelectionModeEnabled == true
        {
            if arrSelectedIndexPaths.contains(indexPath)
            {
                arrSelectedIndexPaths.remove(at: arrSelectedIndexPaths.index(of: indexPath)!)
            }
            else
            {
                arrSelectedIndexPaths.append(indexPath)
            }
            if arrSelectedIndexPaths.count > 0
            {
                tabButtonShare.isEnabled = true
                tabButtonDelete.isEnabled = true
            }
            else
            {
                tabButtonShare.isEnabled = false
                tabButtonDelete.isEnabled = false
            }
            collectionView.reloadData()
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhotoZoomingViewController") as? PhotoZoomingViewController
            vc?.arrPhotos = arrPhotos
            vc?.currentIndex = indexPath.item
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHOTOCELL", for: indexPath) as? PhotoCollectionViewCell
        let photo = arrPhotos[indexPath.item]
        let imageName = String(format: "%@.jpg", photo.imageName!)
        cell?.imageViewTile.image = UIImage(contentsOfFile: GlobalMethods.getImageForName(name: imageName))
        if arrSelectedIndexPaths.contains(indexPath)
        {
            cell?.imageViewCheck.isHidden = false
        }
        else
        {
            cell?.imageViewCheck.isHidden = true
        }
        return cell!
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = (collectionView.frame.size.width - 6)/4
        return CGSize(width: cellSize, height: cellSize)
    }
}
