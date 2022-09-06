//
//  PhotoBrowser.swift
//  PhotoBrowser
//
//  Created by Pravin on 06/09/22.
//

import Foundation
import UIKit
import SKPhotoBrowser

@objc(PhotoBrowser)
public class PhotoBrowser : NSObject {
    
    @objc
    public static let shared = PhotoBrowser()
    
    @objc
    public func showImages(urls: [String], initialIndex: Int) -> UIViewController {
        
        var images = [SKLocalPhoto]()
        for url in urls {
            let photo = SKLocalPhoto.photoWithImageURL(url)
            images.append(photo)
        }

        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(initialIndex)
        return browser
    }
    
}


