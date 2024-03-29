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
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            // if ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                ClearBackgroundView()
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    // if ipad
                    if (UIDevice.current.userInterfaceIdiom == .pad){
                        Spacer()
                            .frame(height: 16)
                    }
                    
                    aboutView
                    
                    sourceCodeView
                    
                    linkView
                    
                    recognition
                    
                    betaTesters
                    
                    // if iphone
                    if !(UIDevice.current.userInterfaceIdiom == .pad){
                        Spacer()
                            .frame(height: 95)
                    }
                    
                    // if ipad
                    if (UIDevice.current.userInterfaceIdiom == .pad){
                        Spacer()
                            .frame(height: 16)
                    }
                }
            }
            .if(!(UIDevice.current.userInterfaceIdiom == .pad)) { view in
                view
                    .navigationTitle("About")
            }
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
"""
\tThe \"VerseGroup\" company mission is to provide polished and effective software solutions to all.
"""
            )
            .padding(.horizontal, 10)
        }
    }
}

extension AboutView {
    private var sourceCodeView: some View {
        Group {
            HeaderLabel(name: "Open Source") .padding(.horizontal, 8)
            
            ParagraphLabel(name:
"""
\t\"VerseGroup\" commits to the \"SchoolVerse\" project being open source for 2022 in hope that other developers may learn from our software.
"""
            )
            .padding(.horizontal, 10)
        }
    }
}

extension AboutView {
    private var linkView: some View {
        Group {
            HeaderLabel(name: "Links") .padding(.horizontal, 8)
            
            LinkLabel(name: "TOS & Privacy Policy", link: URL(string: "https://schoolverse.app/privacypolicy")!)
                .padding(10)
            
            LinkLabel(name: "Instagram", link: URL(string: "https://www.instagram.com/schoolverse_app")!)
                .padding(10)
            
            LinkLabel(name: "Github", link: URL(string: "https://github.com/VerseGroup")!)
                .padding(10)
            
            LinkLabel(name: "SchoolVerse Website", link: URL(string: "https://schoolverse.app/")!)
                .padding(10)
            
            LinkLabel(name: "Donations", link: URL(string: "https://www.buymeacoffee.com/schoolverse")!)
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
    
    private var betaTesters: some View {
        Group {
            HeaderLabel(name: "Most Helpful Beta Testers")
                .padding(.horizontal, 8)
            
            ParagraphLabel(name:
                            "\tWe would like to give another shout-out to Maggie Zhang, Joseph Reyes, Isabelle Cai, Rafa Castro, Will Koranteng, Ella Rodriguez, Vivek Malik, Zara Haider and everyone else for helping us during the beta development of SchoolVerse."
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
