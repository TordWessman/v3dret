//
//  SearchView.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @FocusState private var isEditing: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("enter_city_name_placeholder".localized, text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isEditing)
                        .onSubmit {
                            isEditing = false
                            viewModel.load()
                        }
                    Button("search".localized) {
                        isEditing = false
                        viewModel.load()
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .shadow(radius: 4)
                    .padding()
                }
                .padding()

                switch viewModel.state {
                case .idle:
                    Spacer()
                case .loading:
                    Spacer()
                    ProgressView()
                    Spacer()
                case .ready(let locationItemViewModels):
                    List(locationItemViewModels) { locationItemViewModel in
                        NavigationLink(destination: WeatherContainerView(viewModel: locationItemViewModel.detailsViewModel)) {
                            LocationItemView(viewModel: locationItemViewModel)
                        }
                    }
                    //iOS16: .scrollContentBackground(.hidden)
                case .error(let viewModel):
                    ErrorView(viewModel: viewModel)
                case .noResult:
                    Spacer()
                    Text("no_match_for_search".localized)
                    Spacer()
                }
            }
            .navigationTitle("select_city_title".localized)
            Spacer()
        }
        .padding()
        .accentColor(colorScheme == .dark ? .white : .black)

    }
}
