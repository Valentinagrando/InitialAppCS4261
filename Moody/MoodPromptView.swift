//
//  MoodPromptView.swift
//  Moody
//
//  Created by Valentina Grando on 1/30/22.
//

import SwiftUI

struct DayC: Codable {
    var dayComplete: String
    var isSelected: Bool
    var hasMood: Bool
    var mood: String
}


struct MoodPromptView: View {
    
    @ObservedObject var day: Day
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var mp = FetchUserModel()
    
    
    var body: some View {
        
        VStack{
            
            Text("How are you today?").padding(20)
            Text("User \(mp.user?.email ?? "")")
            Text("Your last mood was: \(mp.user?.lastMood ?? "No data yet!")")
            Text("You are entering mood for \(day.dayComplete)")
            //            Spacer()
            VStack{
                //                Spacer()
                Button {
                    self.day.hasMood = true
                    self.day.mood = "good"
                    self.mp.user?.lastMood = "Good :)"
                    self.day.isSelected = true
                    print(mp.user?.email, mp.user?.uid)
                    print(self.day.hasMood,self.day.isSelected,self.day.mood, self.day.backgroundColor)
                    mp.user?.moodDays[self.day.dayComplete] = self.day.mood
                    
                    updateUserInformation()
                    print("updated?")
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("GOOD!").frame(width: 100, height: 50)
                        .foregroundColor(.white)
                        .background(.green).padding()
                        .font(.system(size: 20, weight: .semibold))
                }
                //                Spacer()
                Button {
                    self.day.hasMood = true
                    self.day.mood = "meh"
                    self.mp.user?.lastMood = "Meh :/"
                    self.day.isSelected = true
                    //save [dateComplete:Day()] on firebase
                    mp.user?.moodDays[self.day.dayComplete] = self.day.mood
                    updateUserInformation()
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("MEH...").frame(width: 100, height: 50).foregroundColor(.white).background(.orange).padding().font(.system(size: 20, weight: .semibold))
                }
                //                Spacer()
                Button {
                    self.day.hasMood = true
                    self.day.mood = "bad"
                    self.mp.user?.lastMood = "Bad :("
                    self.day.isSelected = true
                    mp.user?.moodDays[self.day.dayComplete] = self.day.mood
                    updateUserInformation()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("BAD!").frame(width: 100, height: 50).foregroundColor(.white).background(.red).padding().font(.system(size: 20, weight: .semibold))
                }
                
            }.padding()
        }
    }
    private func updateUserInformation() {
        //    @ObservedObject var mp = FetchUserModel()
        guard let user =  mp.user else { return }
        //        if day.mood != user.moodDays[day.dayComplete]{
        //
        //        //    let userData = ["email": self.email, "uid": uid]
        //
        //        }
        print("updating?")
        FirebaseManager.shared.firestore.collection("users")
            .document(user.uid).updateData([
                "moodDays": user.moodDays,
                "lastMood" : user.lastMood
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        
        
        
    }
}





struct MoodPromptView_Previews: PreviewProvider {
    static var previews: some View {
        MoodPromptView(day: Day(date: Date()))
    }
}
