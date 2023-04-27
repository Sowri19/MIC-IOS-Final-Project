//
//  Booking.swift
//  MIC
//
//  Created by Sowri on 4/25/23.
//

import Foundation

class Bookings: ObservableObject {
    @Published var showingBooking: Bool = false
    @Published var selectedBooking: ComedianModel? = nil
}
