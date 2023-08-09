import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var groupsevenText: String = ""
    @State private var groupsixText: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp = false
    @State private var isSignUpActive = false
    @State private var isHomeActive = false
    var body: some View {
    
        NavigationView{
            ZStack {
                    
                    Image("BG2").scaledToFit()
                  
                        
                

         
                    VStack(spacing:20)  {
                        
                      
                        HStack {
                            TextField(StringConstants.kLblEmail, text: $groupsevenText)
                                .font(FontScheme.kBarlowRegular(size: getRelativeHeight(21.0)))
                                .foregroundColor(ColorConstants.Gray300)
                                .padding()
                                .keyboardType(.emailAddress)
                        }
                        VStack {
                            
                                    TextField("Email", text: $email)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(25)
                                 
                        }.padding(.trailing)
                    
                        VStack{
                            
                                    TextField("Password", text: $password)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(25)
                                 
                        }.padding(.trailing)
                  
                  
                        HStack{
                           
                            Button(action: {
                          
                           showSignUp = true
                                
                            }, label: {
                                HStack(spacing: 0) {
                                    Text("Don't have an account? Sign up")
                                        .font(FontScheme.kAveriaSerifLibreRegular(size: getRelativeHeight(21.0)))
                                        .fontWeight(.regular)
                                        .foregroundColor(ColorConstants.Gray300)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: getRelativeWidth(305.0), height: getRelativeHeight(26.0),
                                               alignment: .topLeading)
                                        .padding(.top, getRelativeHeight(51.0))
                                        .padding(.horizontal, getRelativeWidth(0.0))
                                }
                            })
                            .fullScreenCover(isPresented: $showSignUp) {
                                // Present the SignUpView as a full screen cover
                                SignUpView()
                                
                                    .navigationBarHidden(true)
                                
                                    .navigationBarBackButtonHidden(true)
                            }
                        }
                        VStack{
                            Button(action: {isHomeActive = true}, label: {
                                HStack(spacing: 0) {
                                    Text("Log in")
                                        .font(FontScheme
                                            .kAveriaSerifLibreRegular(size: getRelativeHeight(32.0)))
                                        .fontWeight(.regular)
                                        .padding(.horizontal, getRelativeWidth(70.0))
                                        .padding(.vertical, getRelativeHeight(19.0))
                                        .foregroundColor(ColorConstants.Gray300)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                           
                            
                                }
                            }).fullScreenCover(isPresented: $isHomeActive) {
                                // Present the SignUpView as a full screen cover
//                                DashView()
                                HealthViewScreen()
                                
                                    .navigationBarHidden(true)
                                
                                    .navigationBarBackButtonHidden(true)
                            }
                        }
                        .frame(width: getRelativeWidth(208.0), height: getRelativeHeight(67.0),
                               alignment: .topLeading)
                        .background(RoundedCorners(topLeft: 20.0, topRight: 20.0, bottomLeft: 20.0,
                                                   bottomRight: 20.0)
                                .fill(ColorConstants.Bluegray700))
                        .shadow(color: ColorConstants.Black9003f, radius: 4, x: 0, y: 4)
                        .padding(.top, getRelativeHeight(49.0))
                        .padding(.horizontal, getRelativeWidth(10.0))
                      
                    } .padding(.horizontal, getRelativeWidth(60.0))
                        .padding(.vertical, getRelativeHeight(14.0))
                        .frame(width: 400)
                        .navigationBarHidden(true)
                }
                .hideNavigationBar()
                .frame(width: UIScreen.main.bounds.width, alignment: .topLeading)
                .background(ColorConstants.Bluegray900)
                .padding(.top, getRelativeHeight(30.0))
                .padding(.bottom, getRelativeHeight(10.0))
            
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(ColorConstants.Bluegray900)
                .ignoresSafeArea()
            .hideNavigationBar()
        }
        }
       
    }
   

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LoginView()
        }
    }
}
