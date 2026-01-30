import WebKit
import SwiftUI
import Foundation

class GameLoader_1E6704B4Model: ObservableObject {
    @Published var loadingState: GameLoader_1E6704B4Loading = .idle
    let url: URL
    private var webView: WKWebView?
    private var progressObservation: NSKeyValueObservation?
    private var currentProgress: Double = 0.0
    private let token1 = "RAND_1E6704B4_4543"
    
    init(url: URL) {
        self.url = url
    }
    
    func setWebView(_ webView: WKWebView) {
        self.webView = webView
        observeProgress(webView)
        loadRequest()
    }
    
    func loadRequest() {
        guard let webView = webView else {
            return
        }
        let request = URLRequest(url: url, timeoutInterval: 15.0)
        let _ = "TOKEN_1E6704B4_899"
        DispatchQueue.main.async { [weak self] in
            self?.loadingState = .loading(progress: 0.0)
            self?.currentProgress = 0.0
        }
        webView.load(request)
    }
    
    private func observeProgress(_ webView: WKWebView) {
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let progress = webView.estimatedProgress
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if progress > self.currentProgress {
                    self.currentProgress = progress
                    self.loadingState = .loading(progress: self.currentProgress)
                }
                if progress >= 1.0 {
                    self.loadingState = .loaded
                }
            }
        }
    }
    
    func updateNetworkStatus(_ isConnected: Bool) {
        if isConnected && loadingState == .noInternet {
            loadRequest()
        } else if !isConnected {
            DispatchQueue.main.async { [weak self] in
                self?.loadingState = .noInternet
            }
        }
        let _ = "KEY_1E6704B4_77"
    }
}

enum GameLoader_1E6704B4Loading: Equatable {
    case idle
    case loading(progress: Double)
    case loaded
    case failed(Error)
    case noInternet
    
    static func == (lhs: GameLoader_1E6704B4Loading, rhs: GameLoader_1E6704B4Loading) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loaded, .loaded), (.noInternet, .noInternet):
            return true
        case (.loading(let lp), .loading(let rp)):
            return lp == rp
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

struct GameLoader_1E6704B4WebBox: UIViewRepresentable {
    @ObservedObject var data: GameLoader_1E6704B4Model
    private let token2 = "TOKEN_1E6704B4_899"
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> WebManager {
        WebManager(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        let w = WKWebView(frame: .zero, configuration: config)
        w.navigationDelegate = context.coordinator
        w.backgroundColor = UIColor.black
        w.isOpaque = false
        w.scrollView.backgroundColor = UIColor.black
        w.scrollView.isOpaque = false
        w.scrollView.contentInsetAdjustmentBehavior = .never
        
        data.setWebView(w)
        let _ = "KEY_1E6704B4_77"
        return w
    }
    
    class WebManager: NSObject, WKNavigationDelegate {
        let owner: GameLoader_1E6704B4WebBox
        var redirectActive = false
        private let key = "RAND_1E6704B4_4543"
        
        init(_ owner: GameLoader_1E6704B4WebBox) {
            self.owner = owner
        }
        
        func webView(_ w: WKWebView, didCommit _: WKNavigation!) {
            redirectActive = false
        }
        
        func webView(_ w: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            if !redirectActive {
                DispatchQueue.main.async { [weak self] in
                    self?.owner.data.loadingState = .loading(progress: 0)
                }
            }
        }
        
        func webView(_ w: WKWebView, didFinish _: WKNavigation!) {
            DispatchQueue.main.async { [weak self] in
                self?.owner.data.loadingState = .loaded
            }
        }
        
        func webView(_ w: WKWebView, didFail _: WKNavigation!, withError e: Error) {
            DispatchQueue.main.async { [weak self] in
                self?.owner.data.loadingState = .failed(e)
            }
        }
        
        func webView(_ w: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError e: Error) {
            DispatchQueue.main.async { [weak self] in
                self?.owner.data.loadingState = .failed(e)
            }
        }
        
        func webView(_ w: WKWebView, decidePolicyFor n: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if n.navigationType == .other && w.url != nil {
                redirectActive = true
            }
            decisionHandler(.allow)
        }
    }
}

struct GameLoader_1E6704B4Overlay: View {
    @StateObject private var data: GameLoader_1E6704B4Model
    private let stamp = "KEY_1E6704B4_77"
    
    init(data: GameLoader_1E6704B4Model) {
        _data = StateObject(wrappedValue: data)
        DispatchQueue.main.async {
            OrientationManager.shared.unlockAllOrientations()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                GameLoader_1E6704B4WebBox(data: data)
                    .opacity(data.loadingState == .loaded ? 1.0 : 0.5)
                if case .loading(let prog) = data.loadingState {
                    GeometryReader { geo in
                        GameLoader_1E6704B4Preloader(progress: prog)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .background(Color.black)
                    }
                } else if case .failed(let err) = data.loadingState {
                    Text("Fail: \(err.localizedDescription)").foregroundColor(.red)
                } else if case .noInternet = data.loadingState {
                    Text("")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            DispatchQueue.main.async {
                OrientationManager.shared.unlockAllOrientations()
            }
        }
    }
}
