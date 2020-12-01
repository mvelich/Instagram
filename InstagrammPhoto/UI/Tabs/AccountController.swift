//
//  AccountController.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/17/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import UIKit

class AccountController: UIViewController {
    @IBOutlet weak var profilePhotosView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setRounded()
    }
}

extension AccountController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 5
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        cell.backgroundColor = UIColor.red
       // cell.photoImage.image
         return cell
     }
}

extension AccountController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let columns: CGFloat = 3
           let spacing: CGFloat = 1.5
           let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (UIScreen.main.bounds.width - totalHorizontalSpacing) / columns
           let itemSize = CGSize(width: itemWidth, height: itemWidth)

           return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}
