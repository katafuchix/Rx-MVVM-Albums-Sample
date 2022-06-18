//
//  AlbumsCollectionViewController.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class AlbumsCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    public var albums = PublishSubject<[Album]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpViews()
        self.bind()
    }
    
    func setUpViews() {
        self.collectionView.register(R.nib.albumsCollectionViewCell)
    }
    
    func bind() {
        
        self.albums.asObservable().bind(to: self.collectionView.rx.items) { (collectionView, row, element ) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.albumsCollectionViewCell, for:  IndexPath(row : row, section : 0))!
                cell.configure(element)
                return cell
            }.disposed(by: rx.disposeBag)
        
        self.collectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: rx.disposeBag)

    }

}
