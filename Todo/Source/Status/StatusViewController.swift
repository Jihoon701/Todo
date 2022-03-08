//
//  StatusViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/01/17.
//

import UIKit

class StatusViewController: UIViewController {

    @IBAction func BackToHomeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var YearlyStatusColllectionView: UICollectionView!
    override func viewDidLoad() {
        YearlyStatusColllectionView.delegate = self
        YearlyStatusColllectionView.dataSource = self
        YearlyStatusColllectionView.layer.cornerRadius = 5
        YearlyStatusColllectionView.layer.borderColor = UIColor.black.cgColor
        YearlyStatusColllectionView.layer.borderWidth = 2
        
        let YearlyStatusTapGesture = UITapGestureRecognizer(target: self, action: #selector(ExpandStatus))
        YearlyStatusColllectionView.addGestureRecognizer(YearlyStatusTapGesture)
        YearlyStatusColllectionView.isUserInteractionEnabled = true
        
        super.viewDidLoad()
    }
    
    @objc func ExpandStatus() {

    }
}

extension StatusViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 365
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = YearlyStatusColllectionView.dequeueReusableCell(withReuseIdentifier: "YearlyStatusCollectionViewCell", for: indexPath) as! YearlyStatusCollectionViewCell
//        cell.label.text = String(indexPath.item)
        cell.layer.cornerRadius = 3
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

//        cell.backgroundColor = #colorLiteral(red: 0.08902931958, green: 0.1076786593, blue: 0.1299330294, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (YearlyStatusColllectionView.frame.size.height - 20) / 10 - 5
        let width = height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
