//
//  GHFPersistanceManager.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 11/3/22.
//

import Foundation

enum PersistanceAcctionType {
    case add, remove
}

enum GHFPersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: GHFFollower, actionType: PersistanceAcctionType, completed: @escaping (GHFErrorMessage?) -> Void) {
        retreiveFavorites { result in
            switch result {
            case.success(let favorites):
                var retreivedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retreivedFavorites.contains(favorite) else {
                        completed(.alreadyFavorite)
                        return
                    }
                    retreivedFavorites.append(favorite)
                case .remove:
                    retreivedFavorites.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: retreivedFavorites))
            case.failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retreiveFavorites(completed: @escaping(Result<[GHFFollower], GHFErrorMessage>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([GHFFollower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [GHFFollower]) -> GHFErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let econdedFavorites = try encoder.encode(favorites)
            defaults.set(econdedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return.unableToFavorite
        }
    }
}
