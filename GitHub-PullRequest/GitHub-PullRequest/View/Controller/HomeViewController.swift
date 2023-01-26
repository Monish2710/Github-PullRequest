//
//  HomeViewController.swift
//  GitHub-PullRequest
//
//  Created by Monish Kumar on 21/01/23.
//

import CoreData
import UIKit

class HomeViewController: UIViewController, NVActivityIndicatorViewable {
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: GitEntityModel.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.insetsContentViewsToSafeArea = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return tableView
    }()

    private var dataViewModel = DataViewModel()
    private var pageNumber: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
    }

    private func setupUI() {
        startAnimating(CGSize(width: 150, height: 150), message: "Loading...", type: .ballScaleMultiple, fadeInAnimation: nil)
        setupNavigation()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.spaceAround()
        tableView.register(HomeListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(HomeListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavigation() {
        title = "Pull Request"
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }

    private func initViewModel() {
        do {
            try fetchedhResultController.performFetch()
        } catch let error {
            print("ERROR: \(error)")
        }
        dataViewModel.showError = {
            DispatchQueue.main.async { self.showAlert("Ups, Something Went Wrong") }
        }
        dataViewModel.showLoading = {
            DispatchQueue.main.async { NVActivityIndicatorPresenter.sharedInstance.setMessage("Fetching...") }
        }
        dataViewModel.hideLoading = { }
        dataViewModel.getResponseData { response in
            self.clearData()
            self.saveInCoreDataWith(array: response)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(HomeListTableViewCell.self), for: indexPath) as? HomeListTableViewCell else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        if let response = fetchedhResultController.object(at: indexPath) as? GitEntityModel {
            cell.configue(data: response)
        }
        stopAnimating()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let response = fetchedhResultController.object(at: indexPath) as? GitEntityModel {
            let viewController = DetailsViewController(urlString: response.htmlURL ?? "www.google.com")
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = .formSheet
            present(navController, animated: true, completion: nil)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            // Pagination Block
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    private func createPhotoEntityFrom(model: ResponseElement) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let responseEntity = NSEntityDescription.insertNewObject(forEntityName: "GitEntityModel", into: context) as? GitEntityModel {
            responseEntity.title = model.title
            responseEntity.createdDate = model.createdAt
            responseEntity.updatedDate = model.updatedAt
            responseEntity.userName = model.user?.login
            responseEntity.avatarURL = model.user?.avatarURL
            responseEntity.htmlURL = model.htmlURL
            return responseEntity
        }
        return nil
    }

    private func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: GitEntityModel.self))
            do {
                let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map { $0.map { context.delete($0) }}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    private func saveInCoreDataWith(array: Response) {
        _ = array.compactMap { self.createPhotoEntityFrom(model: $0) }
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        UIView.performWithoutAnimation {
            self.tableView.endUpdates()
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
        }
    }
}
