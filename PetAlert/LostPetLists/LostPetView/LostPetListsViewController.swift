//
//  LostPetListsViewController.swift
//  PetAlert
//
//  Created by vengatesh.c on 05/11/24.
//

import UIKit

class LostPetListsViewController: UIViewController {
    
    //MARK: ------  IBOutlet ------
    @IBOutlet var searchViewOutlet: UIView!
    @IBOutlet var searchbarOulet: UISearchBar!
    @IBOutlet var petListTableView: UITableView!
    @IBOutlet var nodataLbl: UILabel!
    
    //MARK: ------  Variables and Delegate Objects  ------
    var resultData = [dict]()
    weak fileprivate var LostPetViewDelegate: LostPetViewToPresenter?
    fileprivate var LostPetPresenterobj: LostPetPresenter!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        LoadLostPetListDataFromFireBase()
        // Do any additional setup after loading the view.
    }
    // MARK: Setup View
    func setupView() {
        registerTableViewCell()
        self.LostPetPresenterobj = LostPetPresenter()
        self.LostPetViewDelegate =  self.LostPetPresenterobj
        self.LostPetViewDelegate?.setViewDelegate(self)
    }
    
    // MARK: IBActions
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: ------  Load Data From FireBase  ------
    func LoadLostPetListDataFromFireBase()
    {
        self.startActivityIndicator()
        self.LostPetViewDelegate?.loadLostPetDetailsFromFireBase()
    }
}
// MARK: - Extension
extension LostPetListsViewController : UITableViewDelegate,UITableViewDataSource {
    
    //MARK: ------  UITableView Delegates and DataSource  ------
    func registerTableViewCell()
    {
        petListTableView.register(PetListsTableViewCell.nib(), forCellReuseIdentifier: PetListsTableViewCell.cellIdentifier)
        petListTableView.estimatedRowHeight = 385.0
        petListTableView.rowHeight = UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = petListTableView.dequeueReusableCell(withIdentifier: PetListsTableViewCell.cellIdentifier, for: indexPath) as! PetListsTableViewCell
        let dict = resultData[indexPath.row]
        cell.loadCell(petDetailsDict: dict)
        cell.mapviewButton.addTarget(self, action: #selector(mapButtonTap(sender:)), for: .touchUpInside)
        cell.mapviewButton.tag = indexPath.row
        return cell
    }
    @objc func mapButtonTap(sender: UIButton){
        let dict = resultData[sender.tag]
        isMapRequestFromPetListPage = true
        currentPetListData = dict
        self.navigationController?.pushViewController(getViewController.mapScreen.instance, animated: true)
    }
}
// MARK: - Extension
extension LostPetListsViewController : UISearchBarDelegate {
    
    //MARK: ------  UISearchBar Delegate and Logics  ------
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let fetchPredicate = NSPredicate(format: "SELF.petspecies contains[c] %@", searchText)
        resultData = searchText.isEmpty ? petListDatas : petListDatas.filter { fetchPredicate.evaluate(with: $0) }
        if resultData.count == 0 { self.nodataLbl.isHidden = false } else { self.nodataLbl.isHidden = true }
        DispatchQueue.main.async {
            self.petListTableView.reloadData()
        }
    }
    func searchResultData()
    {
        resultData = petListDatas
        emptyData()
    }
    func emptyData()
    {
        if resultData.count == 0 {
            self.searchViewOutlet.isHidden = true
            self.nodataLbl.isHidden = false
        }
    }
}

// MARK: - Extension - Response From FireBase
extension LostPetListsViewController : LostPetPresenterToView {
    
    func SuccessPetListResponse(status: Bool, data: [dict]) {
        resultData = data
        DispatchQueue.main.async {
            self.petListTableView.reloadData()
            self.stopActivityIndicator()
        }
        emptyData()
    }
    func FailurePetListResponse(status: Bool) {
        self.stopActivityIndicator()
        emptyData()
    }
}
