//
//  ContentView.swift
//  Crypto
//
//  Created by Calum Haddow on 18/08/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
