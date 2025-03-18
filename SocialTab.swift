import SwiftUI

struct SocialTab: View {
    @State private var friends: [String] = ["John Doe", "Emily Smith", "Michael Johnson"]
    @State private var selectedFriend: String? = nil
    @State private var showProfile = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    Text("Friends")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)

                    List {
                        ForEach(friends, id: \.self) { friend in
                            Button(action: {
                                selectedFriend = friend
                                showProfile = true
                            }) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                    Text(friend)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            .background(Color.black)
                            .cornerRadius(10)
                        }
                        .onDelete(perform: removeFriend)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black)
                }
                .padding()
            }
            .navigationBarTitle("Social", displayMode: .inline)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showProfile) {
                if let friend = selectedFriend {
                    FriendProfileView(friendName: friend)
                }
            }
        }
    }

    func removeFriend(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
    }
}

// MARK: - Friend Profile View
struct FriendProfileView: View {
    var friendName: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                Text(friendName)
                    .font(.title)
                    .bold()
                    .foregroundColor(.red)

                Text("Recent Activity: Just crushed a workout! 💪")
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
    }
}
