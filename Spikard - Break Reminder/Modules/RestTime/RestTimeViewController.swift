//
//  RestTimeViewController.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

final class RestTimeViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var contentView: NSView!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var pastTimeLabel: NSTextField!
    @IBOutlet private weak var leftTimeLabel: NSTextField!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastTimeLabel.font = NSFont.restViewTimerMonospacedDigitSystemFont
        leftTimeLabel.font = NSFont.restViewTimerMonospacedDigitSystemFont
        updateRestTime(with: SettingsManager.timeInSeconds(for: .restTime))
        NotificationCenter.default.addObserver(self, selector: #selector(tick(notification:)), name: .tick, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    @IBAction private func skipButtonClicked(_ sender: Any) {
        TimerManager.shared.skipRestTime()
    }
    
    // MARK: - Notifications
    
    @objc private func tick(notification: NSNotification) {
        guard let timeLeftInSeconds = notification.userInfo?[kTimeLeftInSecondsKey] as? Int else { return }
        updateRestTime(with: timeLeftInSeconds)
    }
    
    private func updateRestTime(with timeLeftInSeconds: Int) {
        let percentage = 1 - Double(timeLeftInSeconds) / Double(SettingsManager.timeInSeconds(for: .restTime))
        progressIndicator.doubleValue = percentage
        pastTimeLabel.stringValue = TimeConverter.string(from: SettingsManager.timeInSeconds(for: .restTime) - TimerManager.shared.timeLeftInSeconds)
        leftTimeLabel.stringValue = "-" + TimeConverter.string(from: TimerManager.shared.timeLeftInSeconds)
    }
}