import SwiftUI

struct SettingsView: View {
    @Binding var rotationEnabled: Bool
    @Binding var translationEnabled: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Rotation compensation", isOn: $rotationEnabled)
                    Toggle("Translation compensation", isOn: $translationEnabled)
                }

                Section {
                    Text("StayStill is an experiment by Tomas Laurenzo (tomas@laurenzo.net)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
