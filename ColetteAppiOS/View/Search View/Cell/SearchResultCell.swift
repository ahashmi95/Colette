//
//  SearchResultCell.swift
//  SearchAutoComplete
//
//  Created by Amin Fadul on 23/04/2019.
//  Copyright © 2019 AF. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultCell: UICollectionViewCell {

    @IBOutlet weak var srchImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!

    var url: String! {
        didSet {
            self.srchImageView.layer.cornerRadius = 5
            self.srchImageView.layer.masksToBounds = true
            self.srchImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            guard let url = self.url else {return}
            self.srchImageView.sd_imageIndicator?.startAnimatingIndicator()
            self.srchImageView.sd_setImage(with: URL(string: url)) { [weak self](_, _, _, _) in
                if let this = self {
                    this.srchImageView.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }

    private func setupViews() {

        let font = UIFonts.fontBySize(size: 16)
        self.titleLbl.font = font
        self.titleLbl.textColor = UIColor(hex: 0x555555)

        self.priceLbl.font = font
        self.priceLbl.textColor = AppDM.shared.mainColor!
    }
    
    func setUnavailbleImage() {
        srchImageView.image = UIImage(named: "placeholder")
        srchImageView.contentMode = .scaleAspectFit
    }

}

class SearchResultNewCell: UICollectionViewCell {
    
    private lazy var img: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "placeholder")
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var lblPrice:UILabel = {
        let label = UILabel()
        label.font = UIFonts.fontBySize(type: .bold, size: 16)
        label.textColor = UIColors.Default
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    private lazy var lblDiscount: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColors.Dimmed
        lbl.font = UIFonts.fontBySize(type: .bold,size: 14)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        lbl.sizeToFit()
         return lbl
    }()
    
    private lazy var stackPrice: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .trailing
        stack.distribution = .fillProportionally
        stack.sizeToFit()
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .trailing
        stack.distribution = .fillProportionally
        stack.sizeToFit()
        return stack
    }()
    
    private lazy var lblTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
//        label.contentMode = .topRight
        label.font = UIFonts.fontBySize(size: 16)
        label.textColor = UIColors.Default
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(img)
        img.layoutToSuperview(.trailing, offset: -15)
        img.layoutToSuperview(.top, offset: 10)
        img.layoutToSuperview(.bottom, offset: -10)
        img.set(.width, of: 60)
        
        stackPrice.addArrangedSubview(lblDiscount)
        stackPrice.addArrangedSubview(lblPrice)
        
        infoStack.addArrangedSubview(lblTitle)
        infoStack.addArrangedSubview(stackPrice)
        contentView.addSubview(infoStack)
        infoStack.layoutToSuperview(.top, offset: 10)
        infoStack.layoutToSuperview(.bottom, .leading, offset: -10)
        infoStack.layout(.trailing, to: .leading, of: img, offset: -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(product: ProductViewModel) {
        if !product.imageUrl.isEmpty {
            self.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.img.sd_imageIndicator?.startAnimatingIndicator()
            self.img.sd_setImage(with: URL(string: product.imageUrl)) { [weak self](_, _, _, _) in
                if let this = self {
                    this.img.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }
        } else {
            setUnavailbleImage()
        }
        
        if product.hasSpecialPrice {
                lblPrice.text = Tools.price(currancy: product.currancy, price: product.salePrice.description)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: Tools.price(currancy: product.currancy, price: product.price.description)
                )
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                lblDiscount.attributedText = attributeString
                lblDiscount.isHidden = false
            lblPrice.textColor = UIColors.Red
            } else {
                lblDiscount.isHidden = true
                lblPrice.text = Tools.price(currancy: product.currancy, price: product.price.description)
                lblPrice.textColor = UIColors.Default
            }
        
        
//  product.isAvailble {
//                lblCalories.text = "نفذت الكمية"
//            } else {
//                lblCalories.text = " "
//            }
//

        
        lblTitle.text = product.name
    }
    
    func setUnavailbleImage() {
        img.image = UIImage(named: "placeholder")
        img.contentMode = .scaleAspectFit
    }
}

