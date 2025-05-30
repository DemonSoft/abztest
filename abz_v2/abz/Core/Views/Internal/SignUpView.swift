//
//  SignUpView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case name, email, phone
    }

    @EnvironmentObject private var rootVM: ContentVM
    @StateObject private var model = SignUpVM()
    @FocusState private var focusedField: Field?
    @State private var showingOptions = false
    @State private var showingCamera = false
    @State private var showingGallery = false
    
    var body: some View {
        ZStack {
            Color.general
            BodySection()
        }
        .ignoresSafeArea()
        .sheet(isPresented: self.$showingGallery) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$model.selectedImage)
                .ignoresSafeArea()
        }
        .sheet(isPresented: self.$showingCamera) {
            ImagePicker(sourceType: .camera, selectedImage: self.$model.selectedImage)
                .ignoresSafeArea()
        }
        .onAppear() {
            self.model.updateRootVM(self.rootVM)
        }
    }
    
    private func BodySection() -> some View {
        ScrollView {
            VStack {
                VSpacer(24)
                FieldsSection()
                RadioSection()
                UploadPhotoSection()
                BottomSection()
            }
        }
    }
    
    private func FieldsSection() -> some View {
        VStack(spacing: 24) {
            SpecificTextField("User Name", self.$model.name, "Required field", .nameExpression)
                .disableAutocorrection(true)
                .autocapitalization(.words)
                .autocorrectionDisabled()
                .focused(self.$focusedField, equals: .name)
                .keyboardType(.default)
            SpecificTextField("Email", self.$model.email, "Invalid email format", .emailExpression)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .focused(self.$focusedField, equals: .email)
            SpecificTextField("Phone", self.$model.phone, "Required field",  .phoneExpression, "380XXXXXXXXX")
                .keyboardType(.namePhonePad)
                .focused(self.$focusedField, equals: .phone)
        }
        .padding(.horizontal)
    }

    private func RadioSection() -> some View {
        VStack(spacing: 0) {
            VSpacer(24)
            Text("Select your position")
                .foregroundStyle(.black87)
                .spreadWidthLeft()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(self.model.roles, id: \.id) { value in
                        Button {
                            self.model.changeRole(value)
                        } label: {
                            HStack {
                                if self.model.role.id == value.id {
                                    Image.radioCheck
                                } else {
                                    Image.radioUncheck
                                }
                            }
                            Text(value.name)
                                .foregroundStyle(.black87)
                                .spreadWidthLeft()
                        }
                        .spreadWidth()
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func UploadPhotoSection() -> some View {
        VStack {
            Button {
                self.showingOptions.toggle()
            } label: {
                HStack {
                    Text(self.model.picked ? "Photo was selected" : "Upload your photo")
                        .foregroundStyle(.black87)
                        .spreadWidthLeft()
                    
                    Text("Upload")
                        .foregroundStyle(.secondaryNormal)
                        .spreadWidthRight()
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.disabled, lineWidth: 1)
            )
            .confirmationDialog("Choose how you want to add a photo",
                                isPresented: self.$showingOptions, titleVisibility: .visible) {
                            Button("Camera") {
                                self.showingCamera.toggle()
                            }

                            Button("Gallery") {
                                self.showingGallery.toggle()
                            }
                        }

        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func BottomSection() -> some View {
        VStack {
            Button("Sign up") {
                self.model.send()
                    }
            .buttonStyle(PrimaryButtonStyle(140, self.model.available))
        }
        .padding(.bottom)
    }
}

#Preview {
    SignUpView()
}
