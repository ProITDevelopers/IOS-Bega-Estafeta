//
//  ButtonInspectable.swift
//  WebSocket
//
//  Created by Brian Hashirama on 1/9/20.
//  Copyright © 2020 PROIT-CONSULTING. All rights reserved.
//

import UIKit


@IBDesignable class Botao: UIButton {
    
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 0  {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
        
    }

       @IBInspectable var shadowOpacity: Float = 0 {
           didSet {
               layer.shadowOpacity = shadowOpacity
           }
       }

       @IBInspectable var shadowRadius: CGFloat = 0 {
           didSet {
               layer.shadowRadius = shadowRadius
           }
       }

       @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
           didSet {
               layer.shadowOffset = shadowOffset
           }
       }

       @IBInspectable var shadowColor: UIColor? = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0) {
           didSet {
               layer.shadowColor = shadowColor?.cgColor
           }
       }
    
    
    @IBInspectable var borderWidth: CGFloat = 0  {
        didSet {
            layer.borderWidth = borderWidth

        }

    }


    @IBInspectable var borderColor: UIColor?  {

        didSet {
            layer.borderColor = borderColor?.cgColor

        }

    }
    
    
    
    
}



@IBDesignable class View: UIView {
    
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 0  {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
        
    }

       @IBInspectable var shadowOpacity: Float = 0 {
           didSet {
               layer.shadowOpacity = shadowOpacity
           }
       }

       @IBInspectable var shadowRadius: CGFloat = 0 {
           didSet {
               layer.shadowRadius = shadowRadius
           }
       }

       @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
           didSet {
               layer.shadowOffset = shadowOffset
           }
       }

       @IBInspectable var shadowColor: UIColor? = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0) {
           didSet {
               layer.shadowColor = shadowColor?.cgColor
           }
       }
    
    
    @IBInspectable var borderWidth: CGFloat = 0  {
        didSet {
            layer.borderWidth = borderWidth

        }

    }


    @IBInspectable var borderColor: UIColor?  {

        didSet {
            layer.borderColor = borderColor?.cgColor

        }

    }
    
    
    
    
}











class ImagemCircular: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        editView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        editView()
    }
    
    
    
    func editView() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor =  UIColor.init(red: 219/255, green: 169/255, blue: 0/255, alpha: 1).cgColor
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    
    

}



class BotaoCircular: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        editView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        editView()
    }
    
    
    
    func editView() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor =  UIColor.init(red: 255/255, green: 102/255, blue: 0/255, alpha: 1).cgColor
        self.layer.borderWidth = 2
    }
    
    
    

}


class TextLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        editView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        editView()
    }
    
    
    
    func editView() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    
    

}
