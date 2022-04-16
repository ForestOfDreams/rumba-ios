//
//  DummyData.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 04.04.2022.
//

import Foundation


struct DummyData {
    static let task: Task = Task(
        taskId: 1,
        title: "Очистка дна",
        description: "Очистка дна",
        membersCount: 3,
        startDate: Date(),
        endDate: Date(),
        members: [
            Member(
            memberId: 1,
            member: User(
                email: "vlad@gmail.com",
                firstName: "Vladislav",
                lastName: "Shchukin",
                hoursInEvents: 5
            ),
            startDate: Date(),
            endDate: Date()
        )]
    )
    
    static let event: Event = Event(
        eventId: 1,
        title: "Уборка пляжа",
        description: "Необходимо очистить от мусора пляж лазурного озера",
        isOnline: false,
        isCancelled: false,
        isRescheduled: false,
        isActionsRequired: false,
        placeName: "Лазурное озеро",
        latitude: 60.886490560469504,
        longitude: 29.54654745624353,
        startDate: Date.now,
        endDate: Date.now,
        tasks: [],
        members: [],
        creator: Creator(
            accountId: 1,
            firstName: "Петр",
            lastName: "Енотов",
            email: "touch@gmail.com"
        )
    )
}
