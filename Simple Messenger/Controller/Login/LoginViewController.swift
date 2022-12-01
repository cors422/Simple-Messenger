//
//  LoginViewController.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 28.11.2022.
//

import UIKit

class LoginViewController: UIViewController {

    var collectionView: UICollectionView!
    let sliderSlides = SliderSlides()
    var slides: [Slide] = []
    var authVC: AuthViewController!
    var regVC: RegViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        slides = sliderSlides.getSlides()
        
    }
    
    func configCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout )
        layout.minimumLineSpacing = 0
        
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        collectionView.register(UINib(nibName: "SlideCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlideCollectionViewCell")
    }

}

extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideCollectionViewCell", for: indexPath) as! SlideCollectionViewCell
        let slide = slides[indexPath.row]
        cell.delegate = self
        cell.configure(slide: slide )
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
    
    
}

extension LoginViewController: LoginViewControllerDelegate {
    
    func openRegVC() {
        regVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegViewController") as! RegViewController?
        self.view.insertSubview(regVC.view, at: 1)
        regVC.delegate = self
    } 
    
    func openAuthVC() {
        authVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController?
        self.view.insertSubview(authVC.view, at: 1 )
        authVC.delegate = self
        
    }
    
    func closeVC() {
        if regVC != nil {
        regVC.view.removeFromSuperview()
        regVC = nil
        }
        if authVC != nil {
        authVC.view.removeFromSuperview()
        authVC = nil
        }
    }
     
    func startApp() {
        let startVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppViewController")
        self.view.insertSubview(startVC.view, at: 2)
    }
    
}
 
