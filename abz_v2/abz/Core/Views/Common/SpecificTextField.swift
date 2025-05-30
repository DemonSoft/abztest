//
//  SpecificTextField.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct SpecificTextField: View {
    @Binding var value: String
    @State private var placeholder: String
    @State private var regexp: String
    @State private var footer: String
    @State private var mistake: String
    @State private var error: Bool = false

    init(_ placeholder: String,
         _ value: Binding<String>,
         _ mistake: String,
         _ regexp: String = "",
         _ footer: String = "") {
        _value           = value
        self.placeholder = placeholder
        self.regexp      = regexp
        self.footer      = footer
        self.mistake     = mistake
    }
    
    var body: some View {
        ZStack {
            if self.value.count == 0 {
                Text(self.placeholder)
                    .foregroundStyle(.black48)
                    .padding(.horizontal)
                    .spreadWidthLeft()
            }
            
                TextField("", text: self.$value)
                    .textFieldStyle(TextFieldSpecificStyle(self.error, self.placeholder))
                    .autocorrectionDisabled()

            Group {
                if self.error {
                    Text(self.mistake)
                        .foregroundStyle(.error)
                        .padding(.horizontal)
                        .font(.caption)
                        .offset(y: 36)
                        .spreadWidthLeft()
                } 
                else {
                    if self.footer.count > 0 {
                        Text(self.footer)
                            .foregroundStyle(.black60)
                            .padding(.horizontal)
                            .font(.f14())
                            .offset(y: 36)
                            .spreadWidthLeft()
                    }
                }
            }
        }
        .onChange(of: self.value) { oldValue, newValue in
            self.update(newValue)
        }
    }
    
    func update(_ value: String) {
        self.value = value
        self.error = !value.verification(self.regexp, required: false)
        print("is valid - \(!self.error) : \(value)")
    }
}
