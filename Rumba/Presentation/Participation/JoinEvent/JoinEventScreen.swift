//
//  JoinEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct JoinEventScreen: View {
    @StateObject var viewModel: JoinEventViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if let event = viewModel.event {
                    EventDetailView(
                        event: event,
                        image: UIImage(systemName: "qrcode")!,
                        shareAction: {}
                    )
                    TasksListView(
                        tasks: event.tasks ?? [],
                        event: event,
                        showEdit: false
                    )
                }
                else {
                    ProgressView()
                }
                Button {
                    viewModel.joinEvent()
                } label: {
                    Text("Join")
                }
                .buttonStyle(PrimaryButton())
            }
            .padding()
        }
        
    }
}

//struct JoinEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        JoinEventView(
//            event: Event(
//                eventId: 1,
//                title: "Уборка пляжа",
//                description: "Необходимо очистить от мусора пляж лазурного озера",
//                isOnline: false,
//                isCancelled: false,
//                isRescheduled: false,
//                latitude: 43,
//                longitude: 34,
//                startDate: Date.now,
//                endDate: Date.now,
//                tasks: [],
//                creator: Creator(
//                    accountId: 1,
//                    firstName: "Петр",
//                    lastName: "Енотов",
//                    email: "touch@gmail.com")
//            ),
//            joinEvent: {}
//        )
//    }
//}
