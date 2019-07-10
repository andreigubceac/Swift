//
//  UICollectionFlowLayout-ItemSize.swift
//  Jumppi
//
//  Created by Andrei Gubceac on 10/07/2019.
//  Copyright © 2019 Pickapal Inc. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
  
  func computeSquareItemSize(nrOfColumns: UInt = 1) {
    guard let collectionView = collectionView else {
      return
    }
    var size = collectionView.frame.width - (sectionInset.left + sectionInset.right)
    size -= CGFloat(nrOfColumns - 1) * minimumInteritemSpacing
    size /= CGFloat(nrOfColumns)
    itemSize = CGSize(width: size, height: size)
  }

}
