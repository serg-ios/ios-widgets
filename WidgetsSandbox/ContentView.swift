//
//  ContentView.swift
//  WidgetsSandbox
//
//  Created by Sergio Rodríguez Rama on 23/4/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onOpenURL { url in
                print("URL received: \(url)")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
