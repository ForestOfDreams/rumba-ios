//
//  PrimaryButton.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 04.04.2022.
//

import Foundation
import SwiftUI

struct PrimaryButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(
                maxWidth: .infinity,
                minHeight: 44,
                alignment: .center
            )
            .background(isEnabled ? Color.blue : .gray)
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .font(.system(size: 16, weight: .bold))
            .cornerRadius(8)
    }
}
