//
//  GHFErrorMessage.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 10/31/22.
//

import Foundation

enum GHFErrorMessage: String, Error {
    case invalidUserName = "This username created an invalid request."
    case unableToComplete = "Unable to complete request, you may have reached GitHub's limit. Please try again later."
    case invalidData = "The data received from the server is invalid. Please try again."
    case unableToFavorite = "There was an error adding this user to favorites. Please try again."
    case alreadyFavorite = "You've already added this user to your favorites."
}
