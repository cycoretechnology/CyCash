import UIKit

class Mancry_AuthTwoStepsVC: Mac_BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI
    
    let mancry_progressBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let mancry_progressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "jdt_50")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mancry_tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(hex: "#EDF1D8")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SelectTableViewCell.self, forCellReuseIdentifier: "SelectTableViewCell")
        return tableView
    }()
    
    lazy var mancry_continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(hex: "#CEDF00")
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(mancry_workcontinueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    
    var mancry_items: [Mancry_AuthTwoKYCItem] = []
    var mancry_bottomPicker: Mancry_customselectPopupView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#EDF1D8")
        self.mac_publiccustomnavView(title: "Work Information")
        setupUI()
        mancry_gettwoStepinitData()
    }
    
    override func mancry_backbtnAction() {
        let cameraPopView = Mancry_PopView(type: .cameraPermission)
        cameraPopView.configure(
            topImageName: "flbeql_tk_xj",
            title: "Confirm to return?",
            description: "Do you want to pause the authentication and return to the homepage?",
            leftButtonTitle: "Confirm",
            rightButtonTitle: "Cancel"
        )
        cameraPopView.onLeftButtonTapped = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        cameraPopView.show()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        mancry_tableView.dataSource = self
        mancry_tableView.delegate = self
        
        view.addSubview(mancry_progressBgView)
        mancry_progressBgView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(55)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        mancry_progressBgView.addSubview(mancry_progressImageView)
        mancry_progressImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(mancry_tableView)
        mancry_tableView.snp.makeConstraints { make in
            make.top.equalTo(mancry_progressBgView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(mancry_continueButton)
        mancry_continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
        
        mancry_tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        mancry_tableView.snp.makeConstraints { make in
            make.bottom.equalTo(mancry_continueButton.snp.top).offset(-8)
        }
    }
}
