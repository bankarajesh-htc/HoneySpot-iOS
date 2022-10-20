//
//  ConsumerDetailDeliveyTableViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 18/11/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit

class ConsumerDetailDeliveyTableViewCell: UITableViewCell {

    @IBOutlet var deliveryPartnerCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var spotModel : SpotModel!
    var spotSaveModel : SpotSaveModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func prepareCell(spotSavemodel:SpotSaveModel){
        self.spotModel = spotSavemodel.spot
        let delivery = self.spotModel.deliveryOptions?.contains("delivery")
        
        if delivery == nil
        {
            noDataLabel.isHidden = false
            deliveryPartnerCollectionView.isHidden = true
        }
        else
        {
            if !delivery!  {
                noDataLabel.isHidden = false
                deliveryPartnerCollectionView.isHidden = true
                
            }
            else
            {
                noDataLabel.isHidden = true
                deliveryPartnerCollectionView.isHidden = false
                self.spotModel.deliveryOptions?.sort(by: { (s1, s2) -> Bool in
                    if(s1 == "delivery"){
                        return s1 < s2
                    }else{
                        return s1 > s2
                    }
                })
                DispatchQueue.main.async {
                    self.deliveryPartnerCollectionView.reloadData()
                    self.deliveryPartnerCollectionView.collectionViewLayout = self.createLeftAlignedLayoutTag()
                }
            }
        }
        
        
    }

}
extension ConsumerDetailDeliveyTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if spotModel != nil {
            return self.spotModel.deliveryOptions?.filter({ (s) -> Bool in
                return s == "uber-eats" || s == "grubhub" || s == "doordash" || s == "postmates"
            }).count ?? 0
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deliveryPartnerCellId", for: indexPath) as! DeliveryPartnerCollectionViewCell
        let data = self.spotModel.deliveryOptions?.filter({ (s) -> Bool in
            return s == "uber-eats" || s == "grubhub" || s == "doordash" || s == "postmates"
        })[indexPath.row]
        if(data == "uber-eats"){
            cell.image.image = UIImage(named: "ubereats-selected")
        }else if(data == "grubhub"){
            cell.image.image = UIImage(named: "grubhub-selected")
        }else if(data == "doordash"){
            cell.image.image = UIImage(named: "doordash-selected")
        }
        else if(data == "postmates"){
            cell.image.image = UIImage(named: "postmates-selected")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
    
}
extension ConsumerDetailDeliveyTableViewCell {
    
    private func createLeftAlignedLayoutTag() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(100),         // variable width
          heightDimension: .absolute(50)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(40)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
      group.interItemSpacing = .fixed(8)         // horizontal spacing between cells

      return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
    
    private func createLeftAlignedLayoutFavorite() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(40),         // variable width
          heightDimension: .absolute(20)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(20)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
      group.interItemSpacing = .fixed(4)         // horizontal spacing between cells

      return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
    
}
