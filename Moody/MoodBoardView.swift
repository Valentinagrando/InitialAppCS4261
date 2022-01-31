//
//  CalendarView.swift
//  Moody
//
//  Created by Valentina Grando on 1/29/22.
//

import SwiftUI
import FSCalendar
//import MonthCal

struct MoodBoardView: View {
    
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var mp = FetchUserModel()
    
    var body: some View {
        VStack{
            Spacer()
            Text("Mood Calendar").font(.largeTitle).foregroundColor(.pink)
            Text("Mood Calendar is a one instance reflection calendar. Every time you log out the moods in the calendar get erased so that next time you log in you can reflect on your days more fairly!").multilineTextAlignment(.center).font(.subheadline).background(.pink).foregroundColor(.white)
            Text("Happy Reflecting!").font(.subheadline).background(.pink).foregroundColor(.white)
            Spacer()
            CalendarView(start: Date(), monthsToShow: 1)
            Text("PS: Don't worry, we remind you what you very last mood was!").font(.subheadline).foregroundColor(.pink)
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .padding (.vertical, 10)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }.background(Color.pink.opacity(0.7))
                .buttonStyle(PlainButtonStyle())
            }
        }.padding()
            .actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        print("handle sign out")
                        mp.handleSignOut()
                    }),
                        .cancel()
                ])
            }.fullScreenCover(isPresented: $mp.isUserCurrentlyLoggedOut, onDismiss: nil) {
                LoginView()
            }

    
    }
}

struct MoodBoard_Previews: PreviewProvider {
    static var previews: some View {
        MoodBoardView()
    }
}
