//
//  DropDownTextField.swift
//  SelfServices
//
//  Created by Owen on 2019-01-14.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

import UIKit

public class DropDownTextField : UITextField{
    
    var arrow : Arrow!
    var table : UITableView!
    var shadow : UIView!
    
    public fileprivate(set) var selectedIndex: Int?
    
    var isShowingList = false
    
    //MARK: - IBInspectable
    @IBInspectable public var rowHeight: CGFloat = 50
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var selectedRowColor: UIColor = AppManager.APP_COLOR
    @IBInspectable public var hideOptionsWhenSelect = true
    @IBInspectable  public var isSearchEnable: Bool = true {
        didSet{
            addGesture()
        }
    }
    
    public var originalPointOnContainView: CGPoint?
    
    
    @IBInspectable public var borderColor: UIColor =  UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable public var listHeight: CGFloat = 150{
        didSet {
            
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    //Variables
    fileprivate  var tableheightX: CGFloat = 100
    fileprivate  var dataArray = [String]()
    public var optionArray = [String]() {
        didSet{
            if self.optionArray.count > 0 {
                self.arrow.isHidden = false
                self.dataArray = self.optionArray
            } else {
                self.arrow.isHidden = true
            }
        }
    }
    public var optionIds : [String]?
    var searchText = String() {
        didSet{
            if searchText == "" {
                self.dataArray = self.optionArray
            }else{
                self.dataArray = optionArray.filter {
                    return $0.range(of: searchText, options: .caseInsensitive) != nil
                }
            }
            reSizeTable()
            selectedIndex = nil
            
            if self.optionArray.count > 0 && self.table != nil {
                self.table.reloadData()
            }
        }
    }
    fileprivate var arrowPadding: CGFloat = 0 {
        didSet{
            let size = arrow.superview!.frame.size.width-(arrowPadding*2)
            arrow.frame = CGRect(x: arrowPadding, y: arrowPadding, width: size, height: size)
        }
    }
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.delegate = self
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
        self.delegate = self
    }
    
    
    //MARK: - Closures
    fileprivate var didSelectCompletion: (String, Int ,String) -> () = {selectedText, index , id  in }
    fileprivate var TableWillAppearCompletion: () -> () = { }
    fileprivate var TableDidAppearCompletion: () -> () = { }
    fileprivate var TableWillDisappearCompletion: () -> () = { }
    fileprivate var TableDidDisappearCompletion: () -> () = { }
    
    func setupUI () {
        let size = self.frame.height
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size - 2*arrowPadding, height: size))
        self.rightView = rightView
        self.rightViewMode = .always
        let arrowContainerView = UIView(frame: rightView.frame)
        self.rightView?.addSubview(arrowContainerView)
        let arrowSize = arrowContainerView.frame.width - (arrowPadding*2)
        arrow = Arrow(origin: CGPoint(x: arrowPadding,
                                      y: arrowContainerView.center.y - (arrowSize/2)),size: arrowSize)
        
        arrowContainerView.addSubview(arrow)
        addGesture()
        
    }
    fileprivate func addGesture (){
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        if isSearchEnable{
            self.rightView?.addGestureRecognizer(gesture)
        }else{
            self.addGestureRecognizer(gesture)
        }
        
    }
    
    public func showList() {
        if self.isShowingList == true || self.optionArray.isEmpty {
            return
        }
        self.isShowingList = true
        
        TableWillAppearCompletion()
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        table = UITableView(frame: CGRect(x: self.originalPointOnContainView?.x ?? self.frame.minX,
                                          y: self.originalPointOnContainView?.y ?? self.frame.minY,
                                          width: self.frame.width,
                                          height: self.frame.height))
        shadow = UIView(frame: CGRect(x: self.originalPointOnContainView?.x ?? self.frame.minX,
                                      y: self.originalPointOnContainView?.y ?? self.frame.minY,
                                      width: self.frame.width,
                                      height: self.frame.height))
        shadow.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.separatorStyle = .none
        table.layer.cornerRadius = 3
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
        
        self.superview?.superview?.insertSubview(shadow, belowSubview: self)
        self.superview?.superview?.insertSubview(table, belowSubview: self)
        self.isSelected = true
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        
                        self.table.frame = CGRect(x: self.originalPointOnContainView?.x ?? self.frame.minX,
                                                  y: (self.originalPointOnContainView?.y ?? self.frame.minY) + self.frame.height + 3,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        
                        self.table.alpha = 1
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow()
                        self.arrow.position = .up
                        
        },
                       completion: { (finish) -> Void in
                        self.startTimerForShowScrollIndicator()
        })
    }
    
    var timerForShowScrollIndicator: Timer?
    private func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
    }
    
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            self.table.flashScrollIndicators()
        }
    }
    
    public func hideList() {
        
        if self.isShowingList == false || self.optionArray.isEmpty {
            return
        }
        
        TableWillDisappearCompletion()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.originalPointOnContainView?.x ?? self.frame.minX,
                                                  y: self.originalPointOnContainView?.y ?? self.frame.minY,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.shadow.alpha = 0
                        self.shadow.frame = self.table.frame
                        self.arrow.position = .down
        },
                       completion: { (didFinish) -> Void in
                        
                        self.shadow.removeFromSuperview()
                        self.table.removeFromSuperview()
                        self.isSelected = false
                        self.TableDidDisappearCompletion()
        })
        
        self.isShowingList = false
    }
    
    @objc public func touchAction() {
        if self.optionArray.count > 0 {
            isSelected ?  hideList() : showList()
        }
    }
    func reSizeTable() {
        if self.optionArray.count <= 0 || self.table == nil {
            return
        }
        
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.originalPointOnContainView?.x  ?? self.frame.minX ,
                                                  y: (self.originalPointOnContainView?.y ?? self.frame.minY) + self.frame.height + 3,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        
                        
        },
                       completion: { (didFinish) -> Void in
                        self.shadow.layer.shadowPath = UIBezierPath(rect: self.table.bounds).cgPath
                        
        })
    }
    
    //MARK: - Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id: String ) -> ()) {
        didSelectCompletion = completion
    }
    
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    
    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }
    
    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }
    
    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }
    
    public func programmingSelect(fieldText: String) {
        guard fieldText != "" else {
            return
        }
        
        if let selected = optionArray.firstIndex(where: {$0 == fieldText}) {
            if let id = optionIds?[selected] {
                self.text = fieldText
                self.searchText = fieldText
                if isSearchEnable == true {
                    self.selectedIndex = 0 //Set as 0, because it already found, so it supposes to be only one item in the table
                } else {
                    self.selectedIndex = selected
                }

                if self.isShowingList == true {
                    self.table.selectRow(at: IndexPath(row: selected, section: 0), animated: false, scrollPosition: .none)
                    self.table.reloadData()
                    touchAction()
                    self.isShowingList = false
                }
                didSelectCompletion(fieldText, selected , id )
            }else{
                self.text = ""
                self.searchText = ""
                self.selectedIndex = nil
                didSelectCompletion(fieldText, selected , "")
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension DropDownTextField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.programmingSelect(fieldText: textField.text?.trimTheEndSpace() ?? "")
        superview?.endEditing(true)
        return false
    }
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        self.selectedIndex = nil
        self.dataArray = self.optionArray
        touchAction()
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isSearchEnable
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            self.searchText = self.text! + string
        }else{
            let subText = self.text?.dropLast()
            self.searchText = String(subText!)
        }
        if !isSelected {
            showList()
        }
        return true;
    }
    
}
///MARK: UITableViewDataSource
extension DropDownTextField: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if indexPath.row != selectedIndex{
            cell!.backgroundColor = rowBackgroundColor
            cell!.textLabel!.textColor = .darkGray
        }else {
            cell?.backgroundColor = selectedRowColor
            cell!.textLabel!.textColor = .white
        }
        
        cell!.textLabel!.text = "\(dataArray[indexPath.row])"
        cell!.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        cell!.tintColor = .white
        cell!.selectionStyle = .none
        cell?.textLabel?.font = self.font
        cell?.textLabel?.textAlignment = self.textAlignment
        return cell!
    }
}
//MARK: - UITableViewDelegate
extension DropDownTextField: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = (indexPath as NSIndexPath).row
        let selectedText = self.dataArray[self.selectedIndex!]
        tableView.cellForRow(at: indexPath)?.alpha = 0
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        tableView.cellForRow(at: indexPath)?.alpha = 1.0
                        tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedRowColor
                        
        } ,
                       completion: { (didFinish) -> Void in
                        self.text = "\(selectedText)"
                        
                        tableView.reloadData()
        })
        if hideOptionsWhenSelect {
            touchAction()
            self.endEditing(true)
        }
        if let selected = optionArray.firstIndex(where: {$0 == selectedText}) {
            if let id = optionIds?[selected] {
                didSelectCompletion(selectedText, selected , id )
            }else{
                didSelectCompletion(selectedText, selected , "")
            }
            
        }
        
    }
}

//MARK: - Arrow
enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    
    var position: Position = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break
                
            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break
                
            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break
                
            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
        self.backgroundColor = .clear
        
//        let lblTiangle = UILabel(frame: CGRect(x: origin.x, y: 0, width: size, height: size))
//        lblTiangle.text = "▽"
//        lblTiangle.textColor = .white
//        self.addSubview(lblTiangle)
        
        let arrowImgView = UIImageView(image: UIImage(named: "ic_dropdown.png"))
        arrowImgView.frame = CGRect(x: origin.x, y: 0, width: size, height: size)
        arrowImgView.contentMode = .scaleAspectFit
        self.addSubview(arrowImgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        //        // Get size
        //        let size = self.layer.frame.width
        //
        //        // Create path
        //        let bezierPath = UIBezierPath()
        //
        //        // Draw points
        //        let qSize = size/4
        //
        //        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        //        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        //        bezierPath.addLine(to: CGPoint(x: size/2, y: qSize*3))
        //        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        //        bezierPath.close()
        //
        //        // Mask to path
        //        let shapeLayer = CAShapeLayer()
        //        shapeLayer.path = bezierPath.cgPath
        //        self.layer.mask = shapeLayer
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
}

