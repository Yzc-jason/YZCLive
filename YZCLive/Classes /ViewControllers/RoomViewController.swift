//
//  RoomViewController.swift
//  YZCLive
//
//  Created by Jason on 2018/1/8.
//  Copyright © 2018年 叶志成. All rights reserved.
//


import UIKit
import IJKMediaFramework

private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = 320

class RoomViewController: UIViewController,Emitterable {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    
    
    fileprivate lazy var chatToolView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var roomVM : RoomViewModel = RoomViewModel()
    fileprivate var player : IJKFFMoviePlayerController?
    var anchor : AnchorModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        loadRoomInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.shutdown()
    }
}


// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setUpBottom()
        setUpInfo()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setUpBottom() {
        chatToolView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolView.delegate = self
        view.addSubview(chatToolView)
        
        giftView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftView)
    }
    
    fileprivate func setUpInfo() {
        bgImageView.setImage(anchor?.pic74)
        iconImageView.setImage(anchor?.pic51)
        nickNameLabel.text = anchor?.name
        roomNumberLabel.text = "\(anchor?.roomid ?? 0)"
        onlineLabel.text = "\(anchor?.focus ?? 0)"
    }
}


// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.giftView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolView.inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
            self.giftView.frame.origin.y = kScreenH
        })
    }
}

// MARK:- 监听键盘的弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (self.view.bounds.height - kChatToolsViewHeight) ? self.view.bounds.height : inputViewY
            self.chatToolView.frame.origin.y = endY
        })
    }
}

extension RoomViewController : ChatToolsViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        log.debug(message)
    }
}

//MARK:- 加载房间数据
extension RoomViewController {
    fileprivate func loadRoomInfo() {
        if let roomid = anchor?.roomid, let uid = anchor?.uid {
            roomVM.loadLiveURL(roomid, uid, {
                self.setUpDisplayView()
            })
        }   
    }
    
    fileprivate func setUpDisplayView() {
        
        IJKFFMoviePlayerController.setLogReport(false)
        
        let url = URL(string: roomVM.liveURL)
        player = IJKFFMoviePlayerController(contentURL: url, with: nil)
        
        if anchor?.push == 1 {
            let screenW = UIScreen.main.bounds.width
            player?.view.frame = CGRect(x: 0, y: 150, width: screenW, height: screenW * 3 / 4)
            player?.view.center = bgImageView.center
        } else {
            player?.view.frame = bgImageView.bounds
        }
        
        bgImageView.addSubview(player!.view)
        
        DispatchQueue.global().async {
            self.player?.prepareToPlay()
            self.player?.play()
        }
    }
}
