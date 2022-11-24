//
//  ToastView.swift
//  Leviathan
//
//  Created by Thomas Bonk on 05.11.22.
//  Source: https://betterprogramming.pub/swiftui-create-a-fancy-toast-component-in-10-minutes-e6bae6021984
//

import SwiftUI

extension Notification.Name {
    static let ShowToast = Notification.Name("__SHOW_TOAST__")
}

struct ToastView: View {
    
    // MARK: - Enumerations
    
    enum ToastStyle {
        case fatalError
        case error
        case warning
        case success
        case info
    }
    
    
    // MARK: - Model
    
    struct Toast: Equatable {
        
        // MARK: - Properties
        
        var type: ToastStyle
        var title: LocalizedStringKey
        var message: LocalizedStringKey
        var error: Error?
        var duration: Double
        var onDismissed: (() -> Void)?
        
        
        // MARK: - Initialization
        
        init(type: ToastStyle, message: LocalizedStringKey, error: Error? = nil, duration: Double = 5, onDismissed: (() -> Void)? = nil) {
            self.type = type
            self.title = type.title
            self.message = message
            self.error = error
            self.duration = duration
            self.onDismissed = onDismissed
        }
        
        
        // MARK: - Methods
        
        func show() {
            update {
                NotificationCenter.default.post(name: .ShowToast, object: self)
            }
        }
        
        
        // MARK: - Equatable
        
        static func == (lhs: ToastView.Toast, rhs: ToastView.Toast) -> Bool {
            lhs.type == rhs.type && lhs.message == rhs.message
        }
    }
    
    
    // MARK: - Public Properties
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: type.iconName)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(type.themeColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                        .foregroundColor(Color.black.opacity(0.6))
                    
                    Text(message)
                        .lineLimit(10)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.black.opacity(0.6))
                    
                    if let error {
                        Text(error.localizedDescription)
                            .lineLimit(10)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                }
                
                Spacer(minLength: 10)
                
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }
                .buttonStyle(.borderless)
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped(),
            alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
    
    var type: ToastStyle
    var title: LocalizedStringKey
    var message: LocalizedStringKey
    var error: Error?
    var onCancelTapped: (() -> Void)
}

extension ToastView.ToastStyle {
    var title: LocalizedStringKey {
        switch self {
            case .info: return LocalizedStringKey("Information")
            case .warning: return LocalizedStringKey("Warning")
            case .success: return LocalizedStringKey("Success")
            case .error: return LocalizedStringKey("Error")
            case .fatalError: return LocalizedStringKey("Fata Error")
        }
    }
    
    var themeColor: Color {
        switch self {
            case .fatalError, .error: return Color.red
            case .warning: return Color.orange
            case .info: return Color.blue
            case .success: return Color.green
        }
    }
    
    var iconName: String {
        switch self {
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .success: return "checkmark.circle.fill"
            case .error: return "exclamationmark.octagon.fill"
            case .fatalError: return "xmark.octagon.fill"
        }
    }
}

struct ToastModifier: ViewModifier {
    
    // MARK: - Public Properties
    
    @Binding
    var toast: ToastView.Toast?
    
    
    // MARK: - Private Properties
    
    @State
    private var workItem: DispatchWorkItem?
    
    
    // MARK: - Methods
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder
    func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(
                    type: toast.type,
                    title: toast.title,
                    message: toast.message,
                    error: toast.error) {
                        dismissToast()
                    }
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        // TODO: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        toast?.onDismissed?()
        
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<ToastView.Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(
            type: .error,
            title: "Error",
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nLorem ipsum dolor sit amet, consectetur adipiscing elit.\nLorem ipsum dolor sit amet, consectetur adipiscing elit.\n") {
                
            }
    }
}
