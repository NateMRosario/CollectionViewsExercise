//
//  ViewController.swift
//  CollectionViews-Exercise
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class MovieReviewViewController: UIViewController {

    var critics = [Critic]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        tableView.dataSource = self
        loadCritics()
    }

    func loadCritics() {
        CriticAPIClient.manager.getCritic(completionHandler: {self.critics = $0}, errorHandler: {print($0)})
    }
}
extension MovieReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
extension MovieReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return critics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CriticCell", for: indexPath) as? CriticTableViewCell {
        let critic = critics[indexPath.row]
        cell.cellNameLabel.text = critic.name
            cell.cellViewImage.image = nil
            guard let imageURL = critic.multimedia?.resource?.image else {return cell}
            ImageAPIClient.manager.loadImage(from: imageURL, completionHandler: {cell.cellViewImage.image = $0}, errorHandler: {print($0)})
        return cell
        }
        return UITableViewCell()
    }
}
