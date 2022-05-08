//
//  UICollectionFlowLayout-ItemSize.swift
//
//  Created by Andrei Gubceac on 10/07/2019.
//

import UIKit

extension UICollectionViewFlowLayout {
  
  func computeSquareItemSize(nrOfColumns: UInt = 1) {
    guard let collectionView = collectionView else { return }
    var size = collectionView.frame.width - (sectionInset.left + sectionInset.right)
    size -= CGFloat(nrOfColumns - 1) * (scrollDirection == .vertical ? minimumLineSpacing : minimumInteritemSpacing)
    size /= CGFloat(nrOfColumns)
    itemSize = CGSize(width: Int(size), height: Int(size))
  }

}
