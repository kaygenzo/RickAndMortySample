//
//  UserDefaultsHelper.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 08/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    private var _defaults = UserDefaults.standard
    private var _statusKey = "status"
    private var _nameKey = "name"
    
    func setName(name: String?) {
        guard let str = name else { return }
        _defaults.set(str, forKey: _nameKey)
        _defaults.synchronize()
    }
    
    func getName() -> String {
        return _defaults.string(forKey: _nameKey) ?? ""
    }
    
    func setStatus(bool: Bool) {
        _defaults.set(bool, forKey: _statusKey)
        _defaults.synchronize()
    }
    
    func getStatus() -> Bool {
        return _defaults.bool(forKey: _statusKey)
    }
    
    func getStatusString() -> String {
        let status = _defaults.bool(forKey: _statusKey)
        if status {
            return "Alive"
        }
        else {
            return "Dead"
        }
    }
}
