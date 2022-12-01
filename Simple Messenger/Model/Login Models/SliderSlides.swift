//
//  SliderSlides.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 28.11.2022.
//

import UIKit

class SliderSlides {
    var slides: [Slide] = []
    func getSlides ()->[Slide] {
    let image1 = UIImage(named: "slide1")!
    let slide1 = Slide(id: 1, text: "test1", image: image1)
    let image2 = UIImage(named: "slide2")!
    let slide2 = Slide(id: 2, text: "test2", image: image2)
    let image3 = UIImage(named: "slide3")!
    let slide3 = Slide(id: 3,  text: "test3", image: image3)
    
    slides.append(slide1)
    slides.append(slide2)
    slides.append(slide3)
    
    return slides
    }
}
