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
    let todo: String
    let description: String?
    let completed: Bool
    let userId: Int
}
