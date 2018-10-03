//
//  AlbumsViewController.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {

    var arrAlbumTitles = ["Photos", "Favorites", "Recently Deleted", "Add Photos"]
    @IBOutlet weak var collectionViewAlbums: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewAlbums.register(UINib(nibName: "AlbumsCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ALBUMSTITLE")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewAlbums.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AlbumsViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let selectedTitle = arrAlbumTitles[indexPath.item]
        if selectedTitle.caseInsensitiveCompare("Add Photos") == .orderedSame
        {
            let addPhotosVC = self.storyboard?.instantiateViewController(withIdentifier: "AddPhotosViewController") as? AddPhotosViewController
            self.navigationController?.pushViewController(addPhotosVC!, animated: true)
        }
        else if selectedTitle.caseInsensitiveCompare("Photos") == .orderedSame
        {
            let photosVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController
            self.navigationController?.pushViewController(photosVC!, animated: true)
        }
        else if selectedTitle.caseInsensitiveCompare("Recently Deleted") == .orderedSame
        {
            let photosVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentlyDeletedViewController") as? RecentlyDeletedViewController
            self.navigationController?.pushViewController(photosVC!, animated: true)
        }
        else if selectedTitle.caseInsensitiveCompare("Favorites") == .orderedSame
        {
            let photosVC = self.storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController
            self.navigationController?.pushViewController(photosVC!, animated: true)
        }
    }
}

extension AlbumsViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAlbumTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ALBUMS", for: indexPath) as? AlbumsCollectionViewCell
        let title = arrAlbumTitles[indexPath.item]
        cell?.labelAlbumTitle.text = title
        if title.caseInsensitiveCompare("Photos") == .orderedSame
        {
            let arrPhotos = CoreDataAccessLayer.getAllPhotos()
            if arrPhotos != nil
            {
                cell?.labelAlbumCount.text = String(format: "%i", (arrPhotos?.count)!)
                if (arrPhotos?.count)! > 0
                {
                    let imageName = (arrPhotos?.last?.imageName)!
                    cell?.imageViewAlbumTile.image = UIImage(contentsOfFile: GlobalMethods.getImageForName(name: String(format: "%@.jpg", imageName)))
                }
            }
            else
            {
                cell?.labelAlbumCount.text = "0"
                cell?.imageViewAlbumTile.image = nil
            }
        }
        else if title.caseInsensitiveCompare("Favorites") == .orderedSame
        {
            let arrPhotos = CoreDataAccessLayer.getFavoriteImages()
            if arrPhotos != nil
            {
                cell?.labelAlbumCount.text = String(format: "%i", (arrPhotos?.count)!)
                if (arrPhotos?.count)! > 0
                {
                    let imageName = (arrPhotos?.last?.imageName)!
                    cell?.imageViewAlbumTile.image = UIImage(contentsOfFile: GlobalMethods.getImageForName(name: String(format: "%@.jpg", imageName)))
                }
            }
            else
            {
                cell?.labelAlbumCount.text = "0"
                cell?.imageViewAlbumTile.image = nil
            }
        }
        else
        {
            cell?.labelAlbumCount.text = ""
            cell?.imageViewAlbumTile.image = nil
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ALBUMSTITLE", for: indexPath)
        return view
    }
}

extension AlbumsViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collectionView.frame.size.width - 10)/2
        return CGSize(width: cellWidth, height: cellWidth + 50)
    }
}
