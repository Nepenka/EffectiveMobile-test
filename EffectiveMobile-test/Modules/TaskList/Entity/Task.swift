//
//  Task.swift
//  EffectiveMobile-test
//
//  Created by Владислав Перелыгин on 30/09/2025.
//



import Foundation

struct Todo: Decodable {
    let todos: [Task]
}

struct Task: Decodable {
    let id: Int
    var todo: String
    var description: String?
    var completed: Bool
    var date: Date?
    let userId: Int
}
