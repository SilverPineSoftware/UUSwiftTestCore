//
//  UUTestView.swift
//  UUSwiftTestCore
//
//  Created by Ryan DeVore on 5/4/25.
//

import Foundation
import Combine
import SwiftUI

public func UUTestHostScene() -> some Scene
{
    return WindowGroup
    {
        UUTestHostView()
    }
}

public extension Notification.Name
{
    static let uuTestSetTitleNotification = Notification.Name("UUTestSetTitleNotification")
    static let uuTestAddLineNotification = Notification.Name("UUTestAddLineNotification")
    static let uuTestSetButtonTitleNotification = Notification.Name("UUTestSetButtonTitleNotification")
    static let uuTestButtonClickedNotification = Notification.Name("UUTestButtonClickedNotification")
}

public func UUTestSetTitle(_ newTitle: String)
{
    NotificationCenter.default.post(name: .uuTestSetTitleNotification, object: newTitle)
}

public func UUTestAddLine(_ newLine: String)
{
    NotificationCenter.default.post(name: .uuTestAddLineNotification, object: newLine)
}

public class UUTestHostViewModel: ObservableObject
{
    @Published var title: String = "Test Name"
    @Published var lines: [String] = []
    @Published var buttonTitle: String = ""
    var buttonClickObject: String? = nil
    
    private var titleNotificationObserver: Any?
    private var lineNotificationObserver: Any?
    private var buttonNotificationObserver: Any?
    private var incomingLines = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init()
    {
        // Debounce incoming lines to avoid rapid bursts adding too fast
        incomingLines
            .sink { [weak self] newLine in
                withAnimation {
                    self?.lines.append(newLine)
                }
            }
            .store(in: &cancellables)
        
        titleNotificationObserver = NotificationCenter.default.addObserver(
            forName: .uuTestSetTitleNotification,
            object: nil,
            queue: .main)
        { [weak self] notification in
            
            if let newTitle = notification.object as? String
            {
                self?.title = newTitle
            }
        }
        
        lineNotificationObserver = NotificationCenter.default.addObserver(
            forName: .uuTestAddLineNotification,
            object: nil,
            queue: .main)
        { [weak self] notification in
            
            if let newLine = notification.object as? String
            {
                self?.incomingLines.send(newLine)
            }
        }
        
        buttonNotificationObserver = NotificationCenter.default.addObserver(
            forName: .uuTestSetButtonTitleNotification,
            object: nil,
            queue: .main)
        { [weak self] notification in
            
            if let buttonTitle = notification.userInfo?["title"] as? String
            {
                self?.buttonTitle = buttonTitle
            }
            
            if let buttonClickObject = notification.object as? String
            {
                self?.buttonClickObject = buttonClickObject
            }
        }
    }
    
    deinit
    {
        if let observer = titleNotificationObserver
        {
            NotificationCenter.default.removeObserver(observer)
        }
        
        if let observer = lineNotificationObserver
        {
            NotificationCenter.default.removeObserver(observer)
        }
        
        if let observer = buttonNotificationObserver
        {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

public struct UUTestHostView: View
{
    @StateObject private var viewModel = UUTestHostViewModel()
    
    public init()
    {
        
    }
    
    public var body: some View
    {
        VStack
        {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollViewReader { proxy in
                List(viewModel.lines.indices, id: \.self) { index in
                    Text(viewModel.lines[index])
                        .transition(.slide)
                        .id(index) // <-- IMPORTANT: Add .id so we can scroll to it
                }
                .onChange(of: viewModel.lines.count) { _ in
                    // Scroll to the last item when lines change
                    if let lastIndex = viewModel.lines.indices.last {
                        withAnimation {
                            proxy.scrollTo(lastIndex, anchor: .bottom)
                        }
                    }
                }
            }
            
            if !viewModel.buttonTitle.isEmpty
            {
                Button(viewModel.buttonTitle)
                {
                    NotificationCenter.default.post(name: .uuTestButtonClickedNotification, object: viewModel.buttonClickObject)
                }
                .padding()
            }
        }
    }
}

/*
#Preview
{
    VStack
    {
        UUTestHostView()
        
        Button("Simulate Add Line")
        {
            NotificationCenter.default.post(name: .uuTestAddLineNotification, object: "Line at \(Date())")
        }
        .padding()
        
        Button("Simulate Set Button Title")
        {
            NotificationCenter.default.post(name: .uuTestSetButtonTitleNotification, object: "buttonClicked", userInfo: ["title": "Click Me \(Date())"])
        }
        .padding()
    }.onAppear()
    {
        NotificationCenter.default.addObserver(
            forName: .uuTestSetButtonTitleNotification,
            object: nil,
            queue: .main)
        { notification in
            
            print("object: \(notification.object ?? "nil")")
        }
    }
}
*/
