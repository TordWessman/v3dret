//
//  ErrorView.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import SwiftUI

struct ErrorViewModel {
    let message: String
    let reload: (() -> ())?

    var canRetry: Bool { reload != nil }
}

struct ErrorView: View {

    let viewModel: ErrorViewModel

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("error_text".localize(viewModel.message))
                    .foregroundColor(colorScheme == .dark ? .orange : .red)
                Spacer()
                if viewModel.canRetry {
                    Button {
                        viewModel.reload?()
                    } label: {
                        Text("retry".localized)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .shadow(radius: 4)
                }

            }
            Spacer()
        }
    }
}
