//
//  ContentView.swift
//  Moody
//
//  Created by Valentina Grando on 1/27/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct LoginView: View {
    let gradient = Gradient(colors: [.red, .orange])
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var createdAccount = false
    @State var showCalendar = false
    
    
    
    var body: some View {
        //        LinearGradient(gradient: gradient, startPoint: .bottomTrailing, endPoint: .topLeading).ignoresSafeArea()
        NavigationView{
            VStack{
                Image("appstore")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 170, height: 150)
                
                ScrollView{
                    VStack(spacing: 16) {
                        Picker(selection: $isLoginMode, label: Text("Picker here")) {
                            Text("Login")
                                .tag(true)
                            Text("Create Account")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle())
                            .padding()
                        
                        TextField ("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(12)
                            .foregroundColor(.black)
                        SecureField("Password", text: $password)
                            .padding(12)
                            .foregroundColor(.black)
                        Spacer()
                        Button {
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoginMode ? "Log In" : "Create Account")
                                    .foregroundColor(.white)
                                    .padding (.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.pink.opacity(0.7))
                                .buttonStyle(PlainButtonStyle())
                            
                        }
                        NavigationLink(destination: MoodBoardView()
                                        .navigationBarHidden(true)
                                        .navigationBarTitle(""),
                                       isActive: $showCalendar) {
                            EmptyView()
                            
                        }
                        
//                        if createdAccount {
//                            displayCreatedAccount()
//                        }
                        Text(self.signupStatus).foregroundColor(.pink)
                        Text(self.loggedin).foregroundColor(.pink)
                    }
                    
                }
                .navigationTitle(isLoginMode ? "Sign In" : "Sign Up")
                .background(Color(.init(red: 245, green:202, blue: 123, alpha: 1)).ignoresSafeArea())
            }
            
        }.navigationViewStyle(StackNavigationViewStyle()).padding()
        
    }
    
    private func handleAction(){
        if isLoginMode {
            logInUser()
        } else {
            createNewAccount()
        }
    }
    
    @State var loggedin = ""
    @State var signupStatus = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                self.signupStatus = "Failed to log in user: \(err)"
                return
            }
            createdAccount = true
            self.signupStatus = "Successfully created user: \(result?.user.uid ?? "")"
            storeUserInformation()
            showCalendar = true
        }
    }
    
    private func logInUser() {
        createdAccount = false
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                self.loggedin = "Failed to log in user: \(err)"
                return
            }
            print("logged in")
            self.loggedin = "Logging in!"
            showCalendar = true
            
//            self.didCompleteLoginProcess()
        }
    }
    
    func displayCreatedAccount() -> some View {
        Group {
            if !createdAccount {
                VStack {
                    Text("")
                }
            } else {
                VStack {
                    Text("Your account was created successfully!").foregroundColor(.green)
                }
            }
        }
    }
    
    private func storeUserInformation() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return }
        
        let userData = ["email": self.email, "uid": uid, "moodDays":[]] as [String : Any]
        
        FirebaseManager.shared.firestore.collection("users")
            .document (uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loggedin = "\(err)"
                    return
                }
                print ("Success")
//                self.didCompleteLoginProcess()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()

//        LoginView(self.didCompleteLoginProcess:{
//
//        })
    }
}
