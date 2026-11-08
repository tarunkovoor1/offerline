import Foundation
import SwiftUI
import CoreData
import AppKit
import UniformTypeIdentifiers
import PDFKit

struct ResumeView: View {
    @ObservedObject var resumeViewModel: ResumeViewModel
    var body: some View {
        TabView {
            ForEach(resumeViewModel.resumes, id: \.self) { resume in
                ResumeTabView(resume: resume).environmentObject(resumeViewModel)
            }
        }
        .onAppear {
            resumeViewModel.loadResume()
        }
        .alert(isPresented: $resumeViewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(resumeViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    openFile()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("Resumes")
    }
    
    func openFile() {
        let openPanel = NSOpenPanel()
        openPanel.title = "Choose a file"
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [UTType.pdf, UTType.rtf, UTType("org.openxmlformats.wordprocessingml.document")!]

        openPanel.begin { (result) in
            if result == .OK, let selectedFile = openPanel.url {
                do {
                    print("Selected file URL: \(selectedFile)")
                    
                    guard selectedFile.startAccessingSecurityScopedResource() else {
                        print("Failed to start accessing security-scoped resource.")
                        return
                    }

                    defer { selectedFile.stopAccessingSecurityScopedResource() }

                    print("Attempting to create bookmark data for URL: \(selectedFile)")
                    let bookmarkData = try selectedFile.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    print("Successfully created bookmark data for URL: \(selectedFile)")

                    resumeViewModel.addResume(bookmarkData: bookmarkData, type: selectedFile.pathExtension, url: selectedFile)

                } catch {
                    print("Error creating bookmark data for URL: \(selectedFile), error: \(error)")
                    resumeViewModel.handleAlert(message: "Failed to add resume due to an error: \(error.localizedDescription)")
                }
            } else {
                print("User clicked on Cancel or failed to select a file.")
            }
        }
    }
}

struct ResumeTabView: View {
    var resume: ResumeData
    @EnvironmentObject var resumeViewModel: ResumeViewModel

    var body: some View {
        VStack {
            Group {
                if resume.type == "pdf" {
                    if let bookmarkData = resume.bookmarkData, let url = resolveBookmarkData(bookmarkData) {
                        PDFViewer(url: url)
                    } else {
                        Text("Failed to resolve bookmark or file does not exist.")
                    }
                } else if resume.type == "rtf" {
                    if let bookmarkData = resume.bookmarkData, let url = resolveBookmarkData(bookmarkData) {
                        RTFViewer(url: url)
                    } else {
                        Text("Failed to resolve bookmark or file does not exist.")
                    }
                    
                } else if resume.type == "docx" {
                    if let bookmarkData = resume.bookmarkData, let url = resolveBookmarkData(bookmarkData) {
                        DOCXViewer(url: url)
                    } else {
                        Text("Failed to resolve bookmark or file does not exist.")
                    }
                } else {
                    Text("Unsupported file type")
                }
            }
            .frame(minWidth: 200, minHeight: 200)

            Spacer()

            VStack {
                Button(action: {
                    resumeViewModel.deleteResume(resume)
                }) {
                    Text("Delete Resume")
                        .foregroundColor(.red)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                }
            }
            .frame(height: 50) // Reduced the height of the bottom view
            .padding(.bottom)
        }
        .tabItem {
            Label("Resume \(resume.resume_number ?? 0)", systemImage: "doc.text")
        }
    }
}


struct DOCXViewer: NSViewRepresentable {
    var url: URL

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .noBorder
        
        let textView = NSTextView(frame: .zero)
        textView.isEditable = false
        textView.isSelectable = true
        textView.autoresizingMask = [.width, .height]
        textView.backgroundColor = NSColor.textBackgroundColor
        scrollView.documentView = textView
        
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            do {
                let docxData = try Data(contentsOf: url)
                if let attributedString = try? NSAttributedString(data: docxData, options: [.documentType: NSAttributedString.DocumentType.officeOpenXML], documentAttributes: nil) {
                    textView.textStorage?.setAttributedString(attributedString)
                } else {
                    textView.textStorage?.setAttributedString(NSAttributedString(string: "Error loading file."))
                }
            } catch {
                print("Failed to load or parse DOCX data: \(error)")
                textView.textStorage?.setAttributedString(NSAttributedString(string: "Error loading file."))
            }
        }
    }
}


struct PDFViewer: NSViewRepresentable {
    var url: URL

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        print("Attempting to load PDF document from URL: \(url)")

        if FileManager.default.fileExists(atPath: url.path) {
            do {
                let data = try Data(contentsOf: url)
                print("Successfully read data from URL: \(url)")

                if let document = PDFDocument(data: data) {
                    nsView.document = document
                    //nsView.goToFirstPage(nil)
                    if let firstPage = document.page(at:0) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            nsView.go(to: firstPage)
                            print("going to first page ", firstPage, "no of pages=",
                                  document.pageCount, " current page=", nsView.currentPage!)
                        }
                    }
                    nsView.layoutDocumentView()
                    print("Successfully created PDFDocument from data")
                } else {
                    print("Failed to create PDFDocument from data")
                }
            } catch {
                print("Error reading data from URL: \(url), error: \(error)")
            }
        } else {
            print("File does not exist at path: \(url.path)")
        }
    }
}

struct RTFViewer: NSViewRepresentable {
    var url: URL

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.borderType = .noBorder
        
        let textView = NSTextView(frame: .zero)
        textView.isEditable = false
        textView.isSelectable = true
        textView.autoresizingMask = [.width, .height]
        textView.backgroundColor = NSColor.textBackgroundColor
        scrollView.documentView = textView
        
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            do {
                let rtfData = try Data(contentsOf: url)
                let attributedString = try NSAttributedString(data: rtfData, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                textView.textStorage?.setAttributedString(attributedString)
            } catch {
                print("Failed to load or parse RTF data: \(error)")
                textView.textStorage?.setAttributedString(NSAttributedString(string: "Error loading file."))
            }
        }
    }
}

func resolveBookmarkData(_ bookmarkData: Data) -> URL? {
    do {
        var isStale = false
        let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
        if isStale {
            print("Bookmark data is stale.")
            let newBookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            return try URL(resolvingBookmarkData: newBookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
        }
        return url
    } catch {
        print("Failed to resolve bookmark data: \(error.localizedDescription)")
        return nil
    }
}

