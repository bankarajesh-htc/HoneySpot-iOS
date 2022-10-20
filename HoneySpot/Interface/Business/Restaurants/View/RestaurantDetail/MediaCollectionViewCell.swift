//
//  MediaCollectionViewCell.swift
//  HoneySpot
//
//  Created by htcuser on 28/10/21.
//  Copyright © 2021 HoneySpot. All rights reserved.
//

import UIKit
import AWSS3

protocol BusinessMediaEditDelegate {
    func imageDeleteTapped(cell: MediaUpdateCollectionViewCell,currentIndex:Int)
}

class MediaCollectionViewCell: UICollectionViewCell,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tagCollectionView: UICollectionView!
    let imagePicker = UIImagePickerController()
    
    var spotModel : SpotModel!
    var tags = [Tag]()
    var currentIndex = 0
    var selectedTag:Tag!
    var mediaImage = [UIImage]()
    var superVc : MediaEditViewController!
    
    var coverPhotoArray = [String]()
    var menuArray = [String]()
    var imagesArray = [String]()
    var indexPath: IndexPath = IndexPath()
    
    
    func prepareCell(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 30
                layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
        //tagCollectionView!.collectionViewLayout = layout
        
        mediaImage.append(UIImage(named: "updateMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        mediaImage.append(UIImage(named: "addMediaImage")!)
        
       // self.tagCollectionView.collectionViewLayout = createLeftAlignedLayoutTag()
        self.coverPhotoArray = spotModel.customerPictures
        self.tagCollectionView.reloadData()
        print(self.tags.count)
    }
    
    func didClickGallery(indexpath:IndexPath, tagData: Tag)  {
        
        self.indexPath = indexpath
        print(self.indexPath.row)
        selectedTag = tagData
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        superVc.present(alert, animated: true)
        
        
    }
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            superVc.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            superVc.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        superVc.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var img: UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if img == nil {
            img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        guard let image = img else {
            return
        }
        let pictureData: Data = image.jpegData(compressionQuality: 0.9)!
        let newImage:UIImage = UIImage(data: pictureData)!
        selectedTag.image = newImage
        //mediaImage.append(newImage)
        
        
        
        DispatchQueue.background(background: {
            // do something in background
            self.superVc.showLoadingHud()
            self.uploadImage(bucketName: "honeyspot-business-images", data: pictureData) { (result) in
                switch(result){
                case .success(let link):
                    DispatchQueue.main.async {
                        print(link)
                       // self.announcementImageView.kf.setImage(with: URL(string: link))
                        if self.currentIndex == 0
                        {
                            if self.indexPath.row == 0 {
                                self.coverPhotoArray.insert(link, at: 0)
                            }
                            else if self.indexPath.row == 1 {
                                self.coverPhotoArray.insert(link, at: 1)
                            }
                            else if self.indexPath.row == 2 {
                                self.coverPhotoArray.insert(link, at: 2)
                            }
                            else if self.indexPath.row == 3 {
                                self.coverPhotoArray.insert(link, at: 3)
                            }
                            else if self.indexPath.row == 4 {
                                self.coverPhotoArray.insert(link, at: 4)
                            }
                        }
                        
                    }
                    self.superVc.hideAllHuds()
                case .failure(let err):
                    print(err.localizedDescription)
                    HSAlertView.showAlert(withTitle: "Problem", message: "There is a problem uploading your image to our server")
                }
            }
        }, completion:{
            // when background job finished, do something in main thread
            self.tagCollectionView.reloadData()
        })
        

        superVc.dismiss(animated: true, completion: nil)
    }
    func uploadImage(bucketName : String,data : Data,completion: @escaping (Result<String,Error>) -> ()){
        
        let remoteName = UUID().uuidString + ".jpg"
        let S3BucketName = bucketName

        let accessKey = "AKIAZBDUQHBVB6XBABEZ"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let transferManager = AWSS3TransferUtility.default()
        transferManager.uploadData(data, bucket: S3BucketName, key: remoteName, contentType: "image/jpeg", expression: expression) { (task, err) in
            if err != nil {
                print("Upload failed with error: (\(err!.localizedDescription))")
                completion(.failure(err!))
            }
            if let HTTPResponse = task.response {
                print(HTTPResponse)
                DispatchQueue.main.async {
                    self.superVc.hideAllHuds()
                }
                let link = "https://" + bucketName + ".s3.us-east-2.amazonaws.com/" + remoteName
                completion(.success(link))
                
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        superVc.dismiss(animated: true, completion: nil)
    }
    
    
}
extension MediaCollectionViewCell : BusinessMediaEditDelegate {
    func imageDeleteTapped(cell: MediaUpdateCollectionViewCell, currentIndex: Int) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tagCollectionView.indexPath(for: cell)
        print("CI..\(currentIndex)..\(indexPath!.row)")
    }
    
    func imageDeleteTapped(cell: MediaUpdateCollectionViewCell) {
        
    }
    
    
    
}

extension MediaCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentIndex == 0 {
           return 5
        }
        else if currentIndex == 1{
           return 5
        }
        else if currentIndex == 2{
            return 5
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = tags[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagMediaCellId", for: indexPath) as! MediaUpdateCollectionViewCell
        cell.delegate = self
        
        cell.bgImage.image = UIImage(named: "updateMediaImage")
        cell.deleteImageButton.isHidden = true
        cell.prepareCell(model: spotModel, currentIndex: currentIndex, indexPath: indexPath)
        
        print("Media Image \(mediaImage[indexPath.row])")
        if currentIndex == 0 {
            if coverPhotoArray.count > 0 {
                for (index,element) in coverPhotoArray.enumerated() {
                    if index == indexPath.row {
                        cell.bgImage.kf.setImage(with: URL(string: coverPhotoArray[indexPath.row]))
                        cell.deleteImageButton.isHidden = false
                    }
                }
            }
        }
        else if currentIndex == 1{
            if spotModel.menuPictures.count > 0 {
                for (index,element) in spotModel.menuPictures.enumerated() {
                    if index == indexPath.row {
                        cell.bgImage.kf.setImage(with: URL(string: spotModel.menuPictures[indexPath.row]))
                        cell.deleteImageButton.isHidden = false
                    }
                }
            }
        }
        else if currentIndex == 2{
            if spotModel.foodPictures.count > 0 {
                for (index,element) in spotModel.foodPictures.enumerated() {
                    if index == indexPath.row {
                        cell.bgImage.kf.setImage(with: URL(string: spotModel.foodPictures[indexPath.row]))
                        cell.deleteImageButton.isHidden = false
                    }
                }
            }
            
        }
        

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        print(currentIndex)
        let tagData = tags[indexPath.row]
        print("Tag Name:\(tagData.name)")
        self.didClickGallery(indexpath: indexPath,tagData: tagData)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140.0, height: 140.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
    
    // Cell Margin
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

}

extension MediaCollectionViewCell {
    
    private func createLeftAlignedLayoutTag() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(140),         // variable width
          heightDimension: .absolute(140)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
      group.interItemSpacing = .fixed(30)         // horizontal spacing between cells
        
        let group1 = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalHeight(1.0), heightDimension: .estimated(10)),
            subitems: [item]
        )
        group1.interItemSpacing = .fixed(30.0)
          
        

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

