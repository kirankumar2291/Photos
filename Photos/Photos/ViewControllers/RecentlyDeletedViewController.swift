//
//  RecentlyDeletedViewController.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit

class RecentlyDeletedViewController: UIViewController {

    @IBOutlet weak var collectionViewPhotos: UICollectionView!

    var arrSelectedIndexPaths = [IndexPath]()
    var isSelectionModeEnabled = false
    var arrPhotos = [Photos]()

    @IBOutlet weak var labelNoItems: UILabel!
    @IBOutlet weak var tabBarRecoverButton: UITabBarItem!
    @IBOutlet weak var tabBarDeleteButton: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Photos"
        let rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        collectionViewPhotos.register(UINib(nibName: "PhotoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PHOTOCELL")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    func reloadData()
    {
        if CoreDataAccessLayer.getDeletedPhotos() != nil
        {
            arrPhotos = CoreDataAccessLayer.getDeletedPhotos()!
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            arrPhotos.removeAll()
        }
        arrSelectedIndexPaths.removeAll()
        isSelectionModeEnabled = false
        tabBarDeleteButton.isEnabled = false
        tabBarRecoverButton.isEnabled = false
        
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
            
            tabBarRecoverButton.isEnabled = true
            tabBarDeleteButton.isEnabled = true
        }
        else
        {
            sender.title = "Select"
            isSelectionModeEnabled = false
            arrSelectedIndexPaths.removeAll()
            collectionViewPhotos.reloadData()
        }
    }
    
    func performDeletionOfSelectedPhotos()
    {
        let actionSheet = UIAlertController(title: "", message: "These items will be deleted.This action cannot be undone.", preferredStyle: .actionSheet)
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
            CoreDataAccessLayer.DeletePhotosPermanently(arrPhotos: arrItemsToDelete)
            self.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }

    func performRecoveryOfSelectedPhotos()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var deleteString = String(format: "Recover %i Photos", arrSelectedIndexPaths.count)
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
            CoreDataAccessLayer.recoverMultiple(arrPhotos: arrItemsToDelete)
            self.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func performDeleteAllPhotos()
    {
        let actionSheet = UIAlertController(title: "", message: "These items will be deleted.This action cannot be undone.", preferredStyle: .actionSheet)
        var deleteString = String(format: "Delete %i Photos", arrPhotos.count)
        if arrSelectedIndexPaths.count == 1
        {
            deleteString.removeLast()
        }
        let deleteButton = UIAlertAction(title: deleteString, style: .default) { (action) in
            CoreDataAccessLayer.DeletePhotosPermanently(arrPhotos: self.arrPhotos)
            self.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func performRecoverAllPhotos()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var deleteString = String(format: "Recover %i Photos", arrPhotos.count)
        if arrSelectedIndexPaths.count == 1
        {
            deleteString.removeLast()
        }
        let deleteButton = UIAlertAction(title: deleteString, style: .default) { (action) in
            CoreDataAccessLayer.recoverMultiple(arrPhotos: self.arrPhotos)
            self.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteButton)
        actionSheet.addAction(cancelButton)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension RecentlyDeletedViewController: UITabBarDelegate
{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 3235
        {
            if item.title?.caseInsensitiveCompare("Delete All") == .orderedSame
            {
                performDeleteAllPhotos()
            }
            else
            {
                performDeletionOfSelectedPhotos()
            }
        }
        else if item.tag == 3236
        {
            if item.title?.caseInsensitiveCompare("Recover All") == .orderedSame
            {
                performRecoverAllPhotos()
            }
            else
            {
                performRecoveryOfSelectedPhotos()
            }
        }
    }
}

extension RecentlyDeletedViewController: UICollectionViewDelegate
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
                tabBarDeleteButton.title = "Delete"
                tabBarRecoverButton.title = "Recover"
                
                tabBarDeleteButton.isEnabled = true
                tabBarRecoverButton.isEnabled = true
            }
            else
            {
                tabBarDeleteButton.title = "Delete All"
                tabBarRecoverButton.title = "Recover All"

                tabBarDeleteButton.isEnabled = false
                tabBarRecoverButton.isEnabled = false
            }
            collectionView.reloadData()
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhotoZoomingViewController") as? PhotoZoomingViewController
            vc?.isFromRecentlyDeleted = true
            vc?.arrPhotos = arrPhotos
            vc?.currentIndex = indexPath.item
            self.navigationController?.pushViewController(vc!, animated: true)

        }
    }
}

extension RecentlyDeletedViewController: UICollectionViewDataSource
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

extension RecentlyDeletedViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = (collectionView.frame.size.width - 6)/4
        return CGSize(width: cellSize, height: cellSize)
    }
}
