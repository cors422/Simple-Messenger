//
//  SlideCollectionViewCell.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 28.11.2022.
//

import UIKit

class SlideCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var desriptionText: UILabel!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var authButton: UIButton!
    
    var delegate: LoginViewControllerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(slide: Slide) {
        slideImage.image = slide.image
        desriptionText.text = slide.text
        if slide.id == 3 {
            regButton.isHidden = false
            authButton.isHidden = false
        }
    }

    @IBAction func regButton(_ sender: Any) {
        delegate.openRegVC()
    }
    @IBAction func authButton(_ sender: Any) {
        delegate.openAuthVC()
    }
}
