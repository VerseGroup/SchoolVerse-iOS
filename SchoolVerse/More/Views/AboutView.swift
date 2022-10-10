//
//  AboutView.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/25/22.
//

// TODO: Create updated message for purpose statement and schoolverse description

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    aboutView
                    
                    sourceCodeView
                    
                    recognition
                    
                    Spacer()
                        .frame(height: 90)
                }
            }
            .navigationTitle("About")
        }
    }
}

extension AboutView {
    private var aboutView: some View {
        Group {
            TitleLabel(name: "SchoolVerse by VerseGroup, LLC")
                .padding(.horizontal, 10)
            
            HeaderLabel(name: "Founders")
                .padding(.horizontal, 8)
            
            SubtitleLabel(name: "Paul Evans, Malcolm Krolick, \n Daniel Shola-Philips, and Steven Yu")
                .padding(.horizontal, 10)
            
            HeaderLabel(name: "Purpose Statement")
                .padding(.horizontal, 8)
            
            ParagraphLabel(name:
                "\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu luctus tortor. Ut neque metus, iaculis a blandit ac, mollis et magna. In hac habitasse platea dictumst. Nullam sodales enim orci, ut posuere tellus commodo sit amet. Fusce ultricies mattis ante, id consequat lacus. Praesent facilisis commodo tortor."
            )
            .padding(.horizontal, 10)
            
            LinkLabel(name: "Click to visit our website", link: URL(string: "https://www.versegroup.tech")!)
                .padding(10)
        }
    }
}

extension AboutView {
    private var sourceCodeView: some View {
        Group {
            HeaderLabel(name: "SchoolVerse Description") .padding(.horizontal, 8)
            
            ParagraphLabel(name:
                "\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu luctus tortor. Ut neque metus, iaculis a blandit ac, mollis et magna. In hac habitasse platea dictumst. Nullam sodales enim orci, ut posuere tellus commodo sit amet. Fusce ultricies mattis ante, id consequat lacus. Praesent facilisis commodo tortor."
            )
            .padding(.horizontal, 10)
            
            
            LinkLabel(name: "Click to visit our Github", link: URL(string: "https://github.com/VerseGroup")!)
                .padding(10)
        }
    }
}


extension AboutView {
    private var recognition: some View {
        Group {
            HeaderLabel(name: "Special Thanks")
                .padding(.horizontal, 8)
            
            ParagraphLabel(name:
                "\tWe would like to give a shout-out to Mrs. Tranchida, Mr. Dioguardi, Mrs. Maguire, Mr. King, Dr. Ying and so many other faculty and students for giving us significant help, support, and feedback vital to the creation of this app for Hackley School."
            )
            .padding(.horizontal, 10)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
