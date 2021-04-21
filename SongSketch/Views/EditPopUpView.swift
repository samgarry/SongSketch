//
//  EditPopUpView.swift
//  SongSketch
//
//  Created by Samuel Garry on 4/20/21.
//

import UIKit

class EditPopUpView: UIView {
    
//    fileprivate let sectionLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = UIFont(name: "Courier New", size: 21)
//        label.text = "Section Name:"
//        label.numberOfLines = 2
//        label.textAlignment = .center
//        return label
//    }()
    
    var sectionTextField: UITextField = {
        let textField = UITextField()
         textField.translatesAutoresizingMaskIntoConstraints = false
         textField.textAlignment = .center
         textField.font = UIFont(name: "Courier New", size: 40)
         textField.textColor = UIColor.white
         textField.text = "Song 1"
         return textField
    }()
    
//    fileprivate let takeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = UIFont(name: "Courier New", size: 21)
//        label.text = "Take Name:"
//        label.numberOfLines = 2
//        label.textAlignment = .center
//        return label
//    }()
    
    var takeTextField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.font = UIFont(name: "Courier New", size: 40)
        //songLabel.font = UIFont.systemFont(ofSize: 24)
        textField.textColor = UIColor.white
        textField.text = "Song 1"
        return textField
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 2/255, green: 41/255, blue: 86/255, alpha: 1)
        v.layer.cornerRadius = 20
        return v
    }()
    
    fileprivate lazy var symbolStack: UIStackView = {
        let edit1 = UIImage(systemName: "pencil")
        let edit2 = UIImage(systemName: "pencil")
        let image = UIImageView(image: edit1?.withRenderingMode(.alwaysTemplate))
        image.tintColor = .white
        let image2 = UIImageView(image: edit2?.withRenderingMode(.alwaysTemplate))
        image2.tintColor = .white
        let stack = UIStackView(arrangedSubviews: [image, image2])
        image.contentMode = .scaleAspectFit
        image2.contentMode = .scaleAspectFit
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    fileprivate lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sectionTextField, takeTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    @objc fileprivate func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    required init(take: Take) {
        super.init(frame: CGRect.zero)
        let backgroundView = UIView()
        self.addSubview(backgroundView)
        backgroundView.pin(to: self)
        backgroundView.backgroundColor = .clear
        
        //Set up the background that will "blurred" out behind the popup window
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        self.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        self.frame = UIScreen.main.bounds
        
        //Set up the section and take textfields to show the proper core data information
        sectionTextField.text = take.section.name
        takeTextField.text = take.name
        
        //Container Constraints
        self.addSubview(container)
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55).isActive = true
        
        //Symbol Stack Constraints
        container.addSubview(symbolStack)
//        symbolStack.spacing = container.bounds.height * 0.2
        symbolStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        symbolStack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.15).isActive = true
        symbolStack.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        symbolStack.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true

        
        //Text Stack Constraints
        container.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: symbolStack.trailingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
//        stack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5).isActive = true
//        stack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20).isActive = true
        
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
