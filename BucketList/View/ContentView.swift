//
//  ContentView.swift
//  BucketList
//
//  Created by Mohanad Ramdan on 30/08/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack{
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate){
                        VStack {
                            Image(systemName: "location.magnifyingglass")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 33, height: 33)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                    
                }
                .ignoresSafeArea()
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.addNewLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                        
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) {
                    viewModel.updateLocation(location: $0)
                }
            }
        }else{
            VStack {
                Text("Welcome to")
                Text("Bucket List")
                    .font(.largeTitle)
                Button(action: viewModel.authenticate) {
                    Label("Login with FaceID", systemImage: "faceid")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accentColor))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
