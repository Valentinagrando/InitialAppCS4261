//
//  FetchUserModel.swift
//  Moody
//
//  Created by Valentina Grando on 1/30/22.
//

import Foundation

class FetchUserModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    private func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
            else {
                print("Could not find user with uid")
                return
                
            }
        
        self.errorMessage = "\(uid)"
        
        FirebaseManager.shared.firestore.collection("users")
            .document (uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: \(error)")
                return
            }
                
            guard let data = snapshot?.data() else {
                print("No data found")
                return
            }
            //print(data)
            self.errorMessage = "Data: \(data.description)"
        
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let lastMood = data["lastMood"] as? String ?? ""
            let moodDays = data["moodDays"] as? ([String:String]) ?? [:]

            self.user = User(uid: uid, email: email, moodDays: moodDays,lastMood: lastMood)
                              
        }
    }
}
