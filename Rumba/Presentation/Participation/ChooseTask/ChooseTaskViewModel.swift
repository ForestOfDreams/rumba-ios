//
//  ChooseTaskViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 28.03.2022.
//

import Foundation

class ChooseTaskViewModel: ObservableObject {
    var taskId: Int
    
    init(eventId:Int) {
        self.eventId = eventId
    }
    
    func tryAssign() {
        
    }
}
