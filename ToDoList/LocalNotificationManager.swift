//
//  LocalNotificationManager.swift
//  ToDoList
//
//  Created by Burak on 17.10.2021.
//

import UIKit

struct NotificationModel {
    let id: UUID
    let title: String
    let detail: String?
    let dateComponents: DateComponents
    let repeats: Bool
}

protocol NotificationManagerProtocol {
    func scheduleNotification(todo: TodoEntity)
    func removeScheduledNotification(todo: TodoEntity)
}

class LocalNotificationManager: NotificationManagerProtocol{
    private var notification: NotificationModel?
    
    func scheduleNotification(todo: TodoEntity) {
        prepareNotificationObject(todo: todo)
        
        if let notificationModel = notification {
            let content = UNMutableNotificationContent()
            content.title = notificationModel.title
            content.body = notificationModel.detail ?? ""
            content.sound = .default
            
            let notificationCenter = UNUserNotificationCenter.current()
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationModel.dateComponents, repeats: notificationModel.repeats)
            let request = UNNotificationRequest(identifier: notificationModel.id.uuidString, content: content, trigger: trigger)
            notificationCenter.add(request)
        }
    }
    
    private func prepareNotificationObject(todo: TodoEntity){
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: todo.completionTime)
        notification = NotificationModel(id: todo.id, title: todo.title, detail: todo.detail, dateComponents: components, repeats: false)
    }
    
    func removeScheduledNotification(todo: TodoEntity) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [todo.id.uuidString])
    }
    
}

