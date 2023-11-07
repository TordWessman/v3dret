//
//  LocationItemView.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import SwiftUI

struct LocationItemView: View {

    let viewModel: LocationItemViewModel

    var body: some View {
        HStack {
            Text(viewModel.title)
            Spacer()
            Text(viewModel.flagEmoji)
        }
    }
}
