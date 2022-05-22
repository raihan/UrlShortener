//
//  UrlShortenerViewController.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/23/22.
//
import Combine
import UIKit

class UrlShortenerViewController: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ShortUrl>
    typealias DataSource = UITableViewDiffableDataSource<Int, ShortUrl>

    private let urlEntryView: UrlEntryView = UrlEntryView()
    private let noShortUrlView: NoShortUrlView = NoShortUrlView()
    private let shortUrlListView: ShortUrlListView = ShortUrlListView()
    
    lazy var activityIndicator = ActivityIndicatorView(style: .medium)
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }

    private let viewModel: UrlShortenerViewModel
    private var bindings = Set<AnyCancellable>()
    
    private var dataSource: DataSource?
    
    init(viewModel: UrlShortenerViewModel = UrlShortenerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView()
        shortUrlListView.shortUrlTableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addSubiews()
        setUpConstraints()
        setUpTableView()
        configureDataSource()
        setUpBindings()
        setUpTargets()
    }
    
    private func setUpTableView() {
        shortUrlListView.shortUrlTableView.register(
            ShortUrlTableViewCell.self,
            forCellReuseIdentifier: ShortUrlTableViewCell.identifier)
    }
    
    private func setUpTargets() {
        urlEntryView.shortenButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    @objc private func onClick() {
        urlEntryView.urlTextField.setupValidationDesign()
        if viewModel.isUrlExists(urlStr: urlEntryView.urlTextField.text ?? "") {
            print("url exists!!")
        }
        else if urlEntryView.urlTextField.isValid
        {
            viewModel.urlShorten()
        }
    }

    private func setUpBindings() {
        
        viewModel.fetchUrlList()
        func bindViewToViewModel() {
            urlEntryView.urlTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.fullUrl, on: viewModel)
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {            
            viewModel.$urlList
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    // deal with short url data
                    self?.updateView()
                })
                .store(in: &bindings)
            
            viewModel.$shortUrl
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    // deal with short url data
                    self?.urlEntryView.urlTextField.text = ""
                    self?.urlEntryView.urlTextField.resignFirstResponder()
                    self?.viewModel.fetchUrlList()
                    self?.updateView()
                })
                .store(in: &bindings)
            
            let stateValueHandler: (UrlShortenerViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.startLoading()
                case .none, .finishedLoading:
                    self?.finishLoading()
                case .error(let error):
                    self?.finishLoading()
                    self?.showError(error)                    
                }
            }
            
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
            
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func updateView() {
        noShortUrlView.isHidden = viewModel.urlList.count != 0
        shortUrlListView.isHidden = viewModel.urlList.count == 0
        updateUrlListView()
    }
    
    private func updateUrlListView() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.urlList)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: "Unable to shorten the url. please try again later!",
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UrlShortenerViewController {
    
    private func addSubiews() {
        let subviews = [noShortUrlView, urlEntryView, shortUrlListView, activityIndicator]
        
        subviews.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func startLoading() {
        view.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            noShortUrlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noShortUrlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noShortUrlView.topAnchor.constraint(equalTo: view.topAnchor),
            noShortUrlView.bottomAnchor.constraint(equalTo: urlEntryView.topAnchor),
            
            shortUrlListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shortUrlListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shortUrlListView.topAnchor.constraint(equalTo: view.topAnchor),
            shortUrlListView.bottomAnchor.constraint(equalTo: urlEntryView.topAnchor)

        ])
        
        NSLayoutConstraint.activate([
            urlEntryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            urlEntryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            urlEntryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            urlEntryView.heightAnchor.constraint(equalToConstant: 215),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50.0)

        ])
    }
}

extension UrlShortenerViewController: UITableViewDelegate {
    
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: shortUrlListView.shortUrlTableView,
            cellProvider: { (tableView, indexPath, shortUrl) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ShortUrlTableViewCell.identifier,
                    for: indexPath) as? ShortUrlTableViewCell
                cell?.viewModel = ShortUrlCellViewModel(shortUrl: shortUrl)
                cell?.onCopy = { [weak self] in
                    self?.viewModel.copyToClipboard(shortUrl: shortUrl)
                    self?.viewModel.fetchUrlList()
                    self?.viewModel.updateCopyStatus(at: indexPath.row)
                    cell?.updateCopidState(isSelected: true)
                }
                
                cell?.onDelete = { [weak self] in
                    self?.viewModel.deleteShortUrl(at: indexPath.row)
                    self?.viewModel.fetchUrlList()
                    self?.updateView()
                }
                return cell
            }
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        lazy var headerLabel: UILabel = {
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Your Link History"
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-SemiBold", size: 17)
            label.textColor = Theme.textColor
            return label
        }()
        
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = Theme.bgPrimaryColor
        return headerView
    }
}
