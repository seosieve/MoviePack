//
//  TrendViewController.swift
//  MoviePack
//
//  Created by 서충원 on 6/10/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class TrendViewController: UIViewController {
    
    let identifier = TrendTableViewCell.identifier
    var trendArr: [Trend] = []
    var creditsArr: [CreditsResult] = []
    
    lazy var trendTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        configureSubviews()
        configureConstraints()
        trendRequest()
    }
    
    func setViews() {
        view.backgroundColor = .white
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = listButton
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = searchButton
        navigationController?.navigationBar.tintColor = .darkGray
    }

    func configureSubviews() {
        view.addSubview(trendTableView)
    }
    
    func configureConstraints() {
        trendTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func trendRequest() {
        view.makeToastActivity(.center)
        TrendManager.shared.trendRequest(router: .trend) { trendResult, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                guard let trendResult = trendResult else { self.view.hideToastActivity(); return }
                
                self.trendArr = trendResult.results
                self.creditsArr = Array(repeating: CreditsResult(), count: trendResult.results.count)
                
                let dispatchGroup = DispatchGroup()
                
                for (index, result) in trendResult.results.enumerated() {
                    dispatchGroup.enter()
                    self.creditsRequest(id: result.id, index: index, dispatchGroup: dispatchGroup)
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.view.hideToastActivity()
                    self.trendTableView.reloadData()
                }
            }
        }
    }
    
    func creditsRequest(id: Int, index: Int, dispatchGroup: DispatchGroup) {
        TrendManager.shared.creditRequest(router: .credit(id: id)) { trendResult, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                guard let trendResult = trendResult else { dispatchGroup.leave(); return }
                self.creditsArr[index] = trendResult
            }
            dispatchGroup.leave()
        }
    }
    
    @objc func detailButtonPressed(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: trendTableView)
        guard let indexPath = trendTableView.indexPathForRow(at: hitPoint) else { return }
        let vc = TrendDetailViewController()
        vc.trend = trendArr[indexPath.row]
        vc.creditsResult = creditsArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trend = trendArr[indexPath.row]
        let credit = creditsArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TrendTableViewCell
        cell.characterLabel.text = "\(credit.cast[0].name), \(credit.cast[1].name), \(credit.cast[2].name)"
        cell.configureCell(trend: trend)
        cell.detailButton.addTarget(self, action: #selector(detailButtonPressed), for: .touchUpInside)
        
        return cell
    }
}
