//
//  UITableView+ScrollToTop.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 23.01.21.
//  Copyright © 2021 Maksim Velich. All rights reserved.
//

import UIKit

extension UITableView {
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
