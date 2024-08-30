//
//  MapAnnotationViewMarker.swift
//  ParkMapper
//
//  Created by Jacob Peacey on 8/22/24.
//

import SwiftUI
struct MapAnnotationViewMarker: View {
    @Binding  var showClosestParksInfoSheet: Bool
    @Binding  var showClosestChildrensPlayAreasInfoSheet: Bool
    @Binding  var showClosestRecreationalGroundInfoSheet: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .opacity(0.2)
            .overlay{
                if showClosestParksInfoSheet {
                    if colorScheme == .light {
                        Image ("park-light-sf-custom")
                            .resizable()
                            .frame(width: 55)
                    } else if colorScheme == .dark {
                        Image ("park-dark-sf-custom")
                            .resizable()
                            .frame(width: 55)
                    }
                } else if showClosestChildrensPlayAreasInfoSheet {
                    if colorScheme == .light {
                        Image ("swing-light-sf-custom")
                            .resizable()
                            .frame(width: 55)
                    } else if colorScheme == .dark {
                        Image ("swing-dark-sf-custom")
                            .resizable()
                            .frame(width: 55)
                    }
                } else if showClosestRecreationalGroundInfoSheet {
                    if colorScheme == .light {
                        Image ("sports-light-sf-custom")
                            .resizable()
                            .frame(width: 55)
                    } else if colorScheme == .dark {
                        Image ("sports-dark-sf-custom")
                            .resizable()
                            .frame(width: 55)
                    }
                }
            }
    }
}
