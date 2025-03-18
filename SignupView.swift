import SwiftUI

struct SignupView: View {
    enum SignupStep: CaseIterable {
        case basicInfo, fitnessGoal, personalStats, workoutSchedule
    }
    
    @State private var currentStep: SignupStep = .basicInfo
    
    // User Info
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    // Fitness Goal
    @State private var selectedGoal = "Lose Weight"
    let fitnessGoals = ["Lose Weight", "Gain Muscle", "Maintain Fitness"]

    // Personal Stats
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var selectedGender = "Male"
    let genders = ["Male", "Female"]

    // Workout Schedule
    @State private var workoutPlan: [String: String] = [
        "Monday": "Rest",
        "Tuesday": "Rest",
        "Wednesday": "Rest",
        "Thursday": "Rest",
        "Friday": "Rest",
        "Saturday": "Rest",
        "Sunday": "Rest"
    ]
    let workoutOptions = ["Rest", "Chest & Triceps", "Back & Biceps", "Legs", "Shoulders ","Arms","Chest & Back", "Custom"]

    var body: some View {
        ZStack {
            GymTheme.background.ignoresSafeArea()

            VStack {
                // ✅ Step Indicator
                HStack {
                    ForEach(SignupStep.allCases, id: \.self) { step in
                        Capsule()
                            .fill(currentStep == step ? Color.green : Color.gray.opacity(0.4))
                            .frame(height: 5)
                            .animation(.easeInOut, value: currentStep)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // ✅ Dynamic Form Steps
                switch currentStep {
                case .basicInfo:
                    basicInfoStep()
                case .fitnessGoal:
                    fitnessGoalStep()
                case .personalStats:
                    personalStatsStep()
                case .workoutSchedule:
                    workoutScheduleStep()
                }

                Spacer()

                // ✅ Next Button
                Button(action: nextStep) {
                    Text(currentStep == .workoutSchedule ? "Create Account" : "Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .animation(.spring(), value: currentStep)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .animation(.easeInOut, value: currentStep)
    } 

    // ✅ Step 1: Basic Info
    private func basicInfoStep() -> some View {
        VStack(spacing: 20) {
            Text("Let's Get Started")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            CustomTextField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
            CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email, keyboardType: .emailAddress)
            CustomTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
            CustomTextField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
        }
        .padding()
    }

    // ✅ Step 2: Fitness Goal
    private func fitnessGoalStep() -> some View {
        VStack(spacing: 20) {
            Text("What’s Your Goal?")
                .font(.title)
                .bold()
                .foregroundColor(.white)

            Picker("Select Goal", selection: $selectedGoal) {
                ForEach(fitnessGoals, id: \.self) { goal in
                    Text(goal).tag(goal)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        .padding()
    }

    // ✅ Step 3: Personal Stats
    private func personalStatsStep() -> some View {
        VStack(spacing: 20) {
            Text("Tell Us About Yourself")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            HStack {
                CustomTextField(icon: "calendar", placeholder: "Age", text: $age)
                CustomTextField(icon: "ruler", placeholder: "Height (cm)", text: $height)
                CustomTextField(icon: "scalemass", placeholder: "Weight (kg)", text: $weight)
            }
            
            Picker("Gender", selection: $selectedGender) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender).tag(gender)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        .padding()
    }

    // ✅ Step 4: Workout Schedule
    private func workoutScheduleStep() -> some View {
        VStack(spacing: 20) {
            Text("Plan Your Workouts")
                .font(.title)
                .bold()
                .foregroundColor(.white)

            ForEach(workoutPlan.keys.sorted(), id: \.self) { day in
                HStack {
                    Text(day)
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)

                    Picker("", selection: Binding(
                        get: { workoutPlan[day] ?? "Rest" },
                        set: { newValue in workoutPlan[day] = newValue }
                    )) {
                        ForEach(workoutOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    // ✅ Navigation Logic
    private func nextStep() {
        switch currentStep {
        case .basicInfo:
            currentStep = .fitnessGoal
        case .fitnessGoal:
            currentStep = .personalStats
        case .personalStats:
            currentStep = .workoutSchedule
        case .workoutSchedule:
            print("Account Created ✅")
        }
    }
}
