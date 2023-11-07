//
//  WeatherViewModel.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-02.
//

import SwiftUI
import Combine

extension GeoLookupItem {

    var title: String {
        if let state {
            return "\(name) (\(state))"
        }
        return name
    }

    /// https://onmyway133.com/posts/how-to-show-flag-emoji-from-country-code-in-swift/
    var flag: String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}

@MainActor
class SearchViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case error(_ viewModel: ErrorViewModel)
        case ready(_ locations: [LocationItemViewModel])
        case noResult
    }

    private let client: WebClient
    private let lang = Locale.current.languageCode ?? "en" //language.languageCode?.identifier ?? "en"

    @Published var searchText: String = "Alaska"
    @Published private(set) var state: State = .idle

    init(client: WebClient = Client(WeatherRequestFactory(apiKey: V3dretConfiguration.shared.apiKey))) {
        self.client = client
    }
    
    func load() {
        if case .loading = state {
            return
        }
        guard searchText.isValidSearchText else {
            return state = .error(ErrorViewModel(message: "error_invalid_search_text".localized, reload: nil))
        }
        state = .loading
//        containerViewModels = [:]
        Task { [weak self] in
            guard let self else { return }
            do {
                let locationModels = try await self.client.send(request: GeoLookupRequest(q: self.searchText)).removeSimilar()
                guard locationModels.count > 0 else {
                    return self.state = .noResult
                }
                let locationItemViewModels = locationModels.map {
                    LocationItemViewModel(title: $0.title, flagEmoji: $0.flag, lon: $0.lon, lat: $0.lat, lang: self.lang, client: self.client)
                }
                self.state = .ready(locationItemViewModels)
            } catch {
                self.state = .error(ErrorViewModel(message: error.localizedDescription, reload: { [weak self] in
                    self?.load()
                }))
            }
        }
    }
}
