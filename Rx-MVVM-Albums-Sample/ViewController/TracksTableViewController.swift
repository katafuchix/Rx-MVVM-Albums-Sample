//
//  TracksTableViewController.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class TracksTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public var tracks = PublishSubject<[Track]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpViews()
        self.bind()
    }
    
    func setUpViews() {
        self.tableView.register(R.nib.tracksTableViewCell)
    }
    
    func bind() {
        
        self.tracks.asObservable().bind(to: self.tableView.rx.items) { (tableView, row, element ) in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tracksTableViewCell, for:  IndexPath(row : row, section : 0))!
                cell.configure(element)
                return cell
            }.disposed(by: rx.disposeBag)
        
        self.tableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: rx.disposeBag)

    }
}
