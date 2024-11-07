//
//  PetListsTableViewCell.swift
//  PetAlert
//
//  Created by vengatesh.c on 05/11/24.
//

import UIKit

class PetListsTableViewCell: UITableViewCell {
    //MARK: ------  IBOutlet ------
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var petSpeciesLabel: UILabel!
    @IBOutlet var petDescriptionLabel: UILabel!
    @IBOutlet var petContactDetailsLabel: UILabel!
    @IBOutlet var mapViewOutlet: UIView!
    @IBOutlet var mapviewButton: UIButton!
    
    //MARK: ------  XIB Initialize  ------
    static let cellIdentifier = "PetListsTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK: ------  Mapping Data to the Cell  ------
    func loadCell(petDetailsDict:dict)
    {
        mapViewOutlet.drawBorder()
        petNameLabel.text = "Name : \(petDetailsDict["petname"] ?? "")"
        petSpeciesLabel.text = "Species : \(petDetailsDict["petspecies"] ?? "")"
        petDescriptionLabel.text = "Description : \(petDetailsDict["petdescription"] ?? "")"
        petContactDetailsLabel.text = "Contact Details : \(petDetailsDict["contactdetails"] ?? "")"
        setImageFromStringrURL(stringUrl: petDetailsDict["petphoto"]!)
    }
    //MARK: ------  Download Image and Mapping to the Cell  ------
    func setImageFromStringrURL(stringUrl: String) {
        petImage.addSymbolEffect(.variableColor,animated: true)
        if let url = URL(string: stringUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Error handling...
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    let downloadedImage = UIImage(data: imageData)
                    self.petImage.removeAllSymbolEffects()
                    self.petImage.setSymbolImage(downloadedImage!, contentTransition: .replace,options: .repeating)
                    self.petImage.setRoundedImage()
                }
            }.resume()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
