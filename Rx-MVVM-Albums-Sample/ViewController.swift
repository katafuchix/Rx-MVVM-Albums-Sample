//
//  ViewController.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/17.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var albumsView: UIView!
    @IBOutlet weak var tracksView: UIView!
    
    private lazy var albumsViewController: AlbumsCollectionViewController = {
        // Instantiate View Controller
        var viewController = R.storyboard.main.albumsCollectionViewController()!
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: self.albumsView)
        return viewController
    }()
    
    private lazy var tracksViewController: TracksTableViewController = {
        // Instantiate View Controller
        var viewController = R.storyboard.main.tracksTableViewController()!
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: self.tracksView)
        return viewController
    }()
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpViews()
        self.bind()
        
        self.viewModel.inputs
            .trigger
            .onNext(())
    }
    
    func setUpViews() {
        self.view.addBlurArea(area: self.view.frame, style: .dark)
    }
    
    func bind() {
        // アルバム情報
        self.viewModel.outputs
            .albums
            .observe(on: MainScheduler.instance)
            .bind(to: self.albumsViewController.albums)
            .disposed(by: rx.disposeBag)
        
        // トラック情報
        self.viewModel.outputs
            .tracks
            .observe(on: MainScheduler.instance)
            .bind(to: self.tracksViewController.tracks)
            .disposed(by: rx.disposeBag)
        
        // 検索中はMBProgressHUDを表示
        self.viewModel.outputs.isLoading.asDriver(onErrorJustReturn: false)
            .drive(MBProgressHUD.rx.isAnimating(view: self.view))
            .disposed(by: rx.disposeBag)
        
        // エラー表示
        self.viewModel.outputs.error
            .subscribe(onNext: { [weak self] error in
                print("error")
                print(error)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "エラー", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
}
