import UIKit

// MARK: - 弹窗主视图
class Mancry_customselectPopupView: UIView {
    
    // MARK: - 配置项（可根据UI图调整）
    private struct Config {
        static let popupWidth: CGFloat = mancry_Width - 40 // 左右边距20
        static let popupHeight: CGFloat = 340      // 弹窗总高度
        static let headerHeight: CGFloat = 60      // 标题栏高度
        static let footerHeight: CGFloat = 80      // 底部按钮栏高度
        static let cornerRadius: CGFloat = 16      // 弹窗圆角
        static let maskAlpha: CGFloat = 0.5        // 遮罩层透明度
        static let cellHeight: CGFloat = 48        // 单元格高度
    }
    
    // MARK: - 组件
    private var maskViews: UIView!                // 背景遮罩层
    private var containerView: UIView!           // 弹窗容器
    private var titleLabel: UILabel!             // 标题标签
    private var titleBackgroundImageView: UIImageView!  // 标题底部背景图片
    private var tableView: UITableView!          // 列表视图
    private var cancelButton: UIButton!          // 取消按钮
    private var confirmButton: UIButton!         // 确认按钮
    
    // MARK: - 数据&回调
    private var dataSource: [String] = []        // 列表数据源
    private var selectedIndex: Int = -1          // 选中项索引
    private var extraActionTitle: String?        // 列表底部额外操作行文案
    var onConfirm: ((Int, String) -> Void)?      // 确认回调
    var onCancel: (() -> Void)?                  // 取消回调
    var onExtraAction: (() -> Void)?             // 底部额外操作行回调
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI搭建
    private func setupUI() {
        backgroundColor = .clear
        
        // 1. 初始化遮罩层
        setupMaskView()
        
        // 2. 初始化弹窗容器
        setupContainerView()
        
        // 3. 初始化标题栏
        setupTitleView()
        
        // 4. 初始化TableView
        setupTableView()
        
        // 5. 初始化底部按钮
        setupBottomButtons()
    }
    
    // 遮罩层
    private func setupMaskView() {
        maskViews = UIView()
        maskViews.backgroundColor = .black
        maskViews.alpha = 0
        maskViews.isUserInteractionEnabled = true
        // 点击遮罩层关闭弹窗
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskTapped))
        tap.cancelsTouchesInView = false  // 不取消子视图的触摸事件
        maskViews.addGestureRecognizer(tap)
        addSubview(maskViews)
    }
    
    // 弹窗容器
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor(hex: "#EDF1D8")
        containerView.layer.cornerRadius = Config.cornerRadius
        containerView.clipsToBounds = true
        containerView.isUserInteractionEnabled = true  // 确保可以交互
        // 添加阴影（可选，根据UI图调整）
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        addSubview(containerView)
    }
    
    // 标题栏
    private func setupTitleView() {
        
        
        titleBackgroundImageView = UIImageView()
        titleBackgroundImageView.image = UIImage(named: "flbeql_tk_btk")
        titleBackgroundImageView.contentMode = .scaleAspectFill
        titleBackgroundImageView.clipsToBounds = true
        containerView.addSubview(titleBackgroundImageView)
        
        
        titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(hex: "#CADC00")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        // 标题底部背景图片
       
    }
    
    // 列表视图
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor(hex: "#EDF1D8")  // 与弹窗背景色一致
        tableView.separatorStyle = .none  // 取消分割线，因为cell之间有间距
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true  // 确保可以交互
        tableView.allowsSelection = true  // 允许选择
        tableView.allowsMultipleSelection = false  // 不允许多选
        tableView.canCancelContentTouches = true  // 允许取消内容触摸
        tableView.delaysContentTouches = false  // 不延迟内容触摸
        // 注册单元格
        tableView.register(CustomPopupCell.self, forCellReuseIdentifier: "CustomPopupCell")
        // 隐藏多余分割线
        tableView.tableFooterView = UIView()
        containerView.addSubview(tableView)
    }
    
    // 底部按钮
    private func setupBottomButtons() {
        // 取消按钮
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = UIColor(hex: "#DFE4C6")
        cancelButton.layer.cornerRadius = 20
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)
        
        // 确认按钮
        confirmButton = UIButton(type: .custom)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(UIColor(hex: "#2C2F20"), for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.backgroundColor = UIColor(hex: "#CADC00")
        confirmButton.layer.cornerRadius = 20
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        containerView.addSubview(confirmButton)
    }
    
    // MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. 遮罩层全屏
        maskViews.frame = bounds
        
        // 2. 弹窗容器居中
        let containerX = (bounds.width - Config.popupWidth) / 2
        let containerY = (bounds.height - Config.popupHeight) / 2
        containerView.frame = CGRect(x: containerX, y: containerY, width: Config.popupWidth, height: Config.popupHeight)
        
        // 3. 标题栏布局
        titleLabel.frame = CGRect(x: 30, y: 7, width: Config.popupWidth - 60, height: Config.headerHeight)
        
        // 3.1 标题底部背景图片布局（在 titleLabel 底部，高度48，左右间距20）
        let backgroundImageX: CGFloat = 20
        let backgroundImageY = Config.headerHeight - 48  // 从标题栏底部向上48
        let backgroundImageWidth = Config.popupWidth - backgroundImageX * 2
        let backgroundImageHeight: CGFloat = 48
        titleBackgroundImageView.frame = CGRect(x: backgroundImageX, y: backgroundImageY, width: backgroundImageWidth, height: backgroundImageHeight)
        
        // 4. TableView布局（标题栏下方 -> 底部按钮上方，左右间距15）
        let tableViewX: CGFloat = 15
        let tableViewY = Config.headerHeight
        let tableViewHeight = Config.popupHeight - Config.headerHeight - Config.footerHeight
        let tableViewWidth = Config.popupWidth - tableViewX * 2
        tableView.frame = CGRect(x: tableViewX, y: tableViewY, width: tableViewWidth, height: tableViewHeight)
        
        // 5. 底部按钮布局
        let buttonY = Config.popupHeight - Config.footerHeight + 8
        let buttonWidth = (Config.popupWidth - 40 - 16) / 2 // 左右边距20，按钮间距16
        cancelButton.frame = CGRect(x: 20, y: buttonY, width: buttonWidth, height: 44)
        confirmButton.frame = CGRect(x: 20 + buttonWidth + 16, y: buttonY, width: buttonWidth, height: 44)
    }
    
    // MARK: - 公开方法
    /// 配置弹窗数据
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - data: 列表数据
    ///   - defaultIndex: 默认选中索引（默认为-1，表示不选中）
    ///   - extraActionTitle: 列表底部额外操作行（如 "+ Add a receiving account"），nil 表示不显示
    func configure(title: String, data: [String], defaultIndex: Int = -1, extraActionTitle: String? = nil) {
        titleLabel.text = title
        dataSource = data
        selectedIndex = defaultIndex  // 默认不选中（-1）
        self.extraActionTitle = extraActionTitle
        tableView.reloadData()
    }
    
    private var mancry_hasExtraAction: Bool {
        return !(extraActionTitle ?? "").isEmpty
    }
    
    private var mancry_extraActionRow: Int {
        return dataSource.count
    }
    
    /// 显示弹窗
    /// - Parameter superView: 父视图（默认keyWindow）
    func show(in superView: UIView? = nil) {
        let targetView = superView ?? UIApplication.shared.keyWindow ?? UIView()
        frame = targetView.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        targetView.addSubview(self)
        
        // 强制布局
        layoutIfNeeded()
        
        // 初始状态
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        // 动画显示
        UIView.animate(withDuration: 0.25) {
            self.maskViews.alpha = Config.maskAlpha
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    /// 隐藏弹窗
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.maskViews.alpha = 0
            self.containerView.alpha = 0
//            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 事件响应
    @objc private func maskTapped(_ gesture: UITapGestureRecognizer) {
        // 检查点击位置是否在 containerView 内
        let location = gesture.location(in: self)
        if containerView.frame.contains(location) {
            // 点击在容器内，不处理（让 tableView 处理）
            return
        }
        // 点击在遮罩层上，关闭弹窗
        dismiss()
        onCancel?()
    }
    
    @objc private func cancelTapped() {
        dismiss()
        onCancel?()
    }
    
    @objc private func confirmTapped() {
        guard selectedIndex >= 0 && selectedIndex < dataSource.count else {
            // 未选中时可提示用户
            self.makeToast("Please choose \(self.titleLabel.text ?? "")", point: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), title: nil, image: nil, completion: nil)
         
            return
        }
        onConfirm?(selectedIndex, dataSource[selectedIndex])
        dismiss()
    }
}

// MARK: - UITableView数据源&代理
extension Mancry_customselectPopupView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + (mancry_hasExtraAction ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPopupCell", for: indexPath) as! CustomPopupCell
        if mancry_hasExtraAction && indexPath.row == mancry_extraActionRow {
            cell.configure(text: extraActionTitle ?? "", isSelected: false, style: .action)
        } else {
            cell.configure(text: dataSource[indexPath.row], isSelected: indexPath.row == selectedIndex, style: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.cellHeight + 10  // cell高度 + 间距10
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if mancry_hasExtraAction && indexPath.row == mancry_extraActionRow {
            dismiss()
            onExtraAction?()
            return
        }
        
        // 取消之前选中项的样式
        if selectedIndex >= 0 && selectedIndex < dataSource.count {
            let prevIndexPath = IndexPath(row: selectedIndex, section: 0)
            if let prevCell = tableView.cellForRow(at: prevIndexPath) as? CustomPopupCell {
                prevCell.configure(text: dataSource[selectedIndex], isSelected: false, style: .normal)
            }
        }
        
        // 更新选中状态
        selectedIndex = indexPath.row
        
        // 更新当前选中项的样式
        if let currentCell = tableView.cellForRow(at: indexPath) as? CustomPopupCell {
            currentCell.configure(text: dataSource[indexPath.row], isSelected: true, style: .normal)
        }
    }
}

// MARK: - 自定义单元格
class CustomPopupCell: UITableViewCell {
    enum Style {
        case normal
        case action
    }
    
    private var contentLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear  // 设置为透明，让间距显示出来
        isUserInteractionEnabled = true  // 确保可以交互
        
        // 设置contentView的初始背景色和圆角
        contentView.backgroundColor = UIColor(hex: "#DFE4C6")
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true  // 确保contentView可以交互
        
        // 文本标签
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = UIColor(hex: "#2C2F20")
        contentLabel.textAlignment = .center  // 文字居中
        contentLabel.isUserInteractionEnabled = false  // 标签不拦截点击事件
        contentView.addSubview(contentLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置contentView的frame，上下各留5的间距，这样两个cell之间就有10的间距
        let spacing: CGFloat = 5
        contentView.frame = CGRect(
            x: 0,
            y: spacing,
            width: bounds.width,
            height: bounds.height - spacing * 2
        )
        
        // 确保 contentView 可以接收触摸事件
        contentView.isUserInteractionEnabled = true
        
        // 文本标签布局
        contentLabel.frame = CGRect(x: 15, y: 0, width: contentView.frame.width - 30, height: contentView.frame.height)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 确保点击事件能正确传递到 cell
        let hitView = super.hitTest(point, with: event)
        // 如果点击在 cell 范围内，确保返回可以接收事件的视图
        if bounds.contains(point) {
            return self
        }
        return hitView
    }
    
    /// 配置单元格
    /// - Parameters:
    ///   - text: 显示文本
    ///   - isSelected: 是否选中
    ///   - style: normal 普通选项 / action 底部操作行
    func configure(text: String, isSelected: Bool, style: Style = .normal) {
        contentLabel.text = text
        
        if style == .action {
            contentView.backgroundColor = UIColor(hex: "#9CAA53")
            contentLabel.textColor = .white
            return
        }
        
        if isSelected {
            // 选中状态：背景色#9CAA53，文字颜色白色
            contentView.backgroundColor = UIColor(hex: "#9CAA53")
            contentLabel.textColor = .white
        } else {
            // 未选中状态：背景色#DFE4C6，文字颜色#2C2F20
            contentView.backgroundColor = UIColor(hex: "#DFE4C6")
            contentLabel.textColor = UIColor(hex: "#2C2F20")
        }
    }
}

// MARK: - UIColor扩展（支持16进制）

