//
//  NotesEditorView.swift
//  Offerline
//
//  Created by Ninan Thomas on 5/24/24.
//

import Foundation
import SwiftUI
import CoreData
import AppKit


class NotesEditorWindowController: NSWindowController, NSWindowDelegate {
    private weak var parentWindow: NSWindow?

    override init(window: NSWindow?) {
        super.init(window: window)
        self.window?.delegate = self
    }

    convenience init(contentView: NotesEditorView, parentWindow: NSWindow?) {
        let hostingController = NSHostingController(rootView: contentView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Edit Notes"
        window.setFrame(NSRect(x: 0, y: 0, width: 600, height: 400), display: true)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.level = .normal
        window.isReleasedWhenClosed = true // Ensure the window releases all resources on close
        
        self.init(window: window)
        self.parentWindow = parentWindow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func windowWillClose(_ notification: Notification) {
        parentWindow?.makeKeyAndOrderFront(nil)
        parentWindow?.contentView?.needsDisplay = true // Force redraw of the parent window
        NSApp.activate(ignoringOtherApps: true)
    }
}


class WindowControllerHolder: ObservableObject {
    var windowController: NSWindowController?
}

struct NotesEditorView: View {
    @ObservedObject var collegeNote: CollegeNote
    @State private var rtfText: NSAttributedString

    init(collegeNote: CollegeNote) {
        self.collegeNote = collegeNote
        self._rtfText = State(initialValue: {
            if let data = collegeNote.noteData,
               let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) {
                return attributedString
            }
            return NSAttributedString(string: "")
        }())
    }

    var body: some View {
        RTFEditorView(rtfData: $rtfText, saveAction: saveNotes)
            .padding()
            .frame(minWidth: 600, minHeight: 400)
    }

    private func saveNotes() {
        do {
            let data = try rtfText.data(from: NSRange(location: 0, length: rtfText.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
            collegeNote.noteData = data
            try collegeNote.managedObjectContext?.save()
        } catch {
            print("Failed to save notes: \(error)")
        }
    }
}

struct RTFEditorView: View {
    @Binding var rtfData: NSAttributedString
    var saveAction: () -> Void

    var body: some View {
        RepresentedNSTextView(rtfData: $rtfData, saveAction: saveAction)
            .frame(minWidth: 600, minHeight: 400)
    }
}

struct RepresentedNSTextView: NSViewRepresentable {
    @Binding var rtfData: NSAttributedString
    var saveAction: () -> Void

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        let textView = NSTextView(frame: scrollView.bounds)
        textView.autoresizingMask = [.width, .height]
        textView.textContainer?.containerSize = NSSize(width: scrollView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        textView.isEditable = true
        textView.usesInspectorBar = true
        textView.isRichText = true
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.textStorage?.setAttributedString(rtfData)
        textView.delegate = context.coordinator

        scrollView.documentView = textView
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        if let textView = scrollView.documentView as? NSTextView {
            if textView.attributedString() != rtfData {
                textView.textStorage?.setAttributedString(rtfData)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, saveAction: saveAction)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RepresentedNSTextView
        var saveAction: () -> Void

        init(_ parent: RepresentedNSTextView, saveAction: @escaping () -> Void) {
            self.parent = parent
            self.saveAction = saveAction
        }

        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                DispatchQueue.main.async {
                    self.parent.rtfData = textView.attributedString()
                    self.saveAction()
                }
            }
        }
    }
}
