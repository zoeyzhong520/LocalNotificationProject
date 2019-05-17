//
//  ViewController.swift
//  LocalNotificationProject
//
//  Created by zhifu360 on 2019/5/17.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    ///创建UIDataPicker
    lazy var dataPicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        picker.center = self.view.center
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.calendar = Calendar.current
        picker.locale = Locale(identifier: "zh")
        picker.addTarget(self, action: #selector(selectDate(_:)), for: .valueChanged)
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setPage()
    }

    func setPage() {
        title = "请设置通知时间"
        view.addSubview(dataPicker)
    }
    
    func setNavigation() {
        //创建完成按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    }
    
    @objc func selectDate(_ picker: UIDatePicker) {
        let date = picker.date
        print(date)
    }
    
    @objc func doneAction() {
        //发送本地通知
        LocalNotificationHandler.sharedHandler.sendLocalNotification()
    }
    
}

