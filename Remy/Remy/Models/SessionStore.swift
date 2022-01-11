//
//  SessionStore.swift
//  Remy
//
//  Created by Jia Chun Xie on 1/8/22.
//

import Foundation
import SwiftUI

class SessionStore: ObservableObject {
    @Published var sleepSessions: [Date: SleepSession] = [:]
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("sessions.data")
    }
    
    static func load() async throws -> [Date: SleepSession] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let sessions):
                    continuation.resume(returning: sessions)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Date: SleepSession], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([:]))
                    }
                    return
                }
                let sleepSessions = try JSONDecoder().decode([Date: SleepSession].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(sleepSessions))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(sleepSessions: [Date: SleepSession]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(sleepSessions: sleepSessions) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let sessionSaved):
                    continuation.resume(returning: sessionSaved)
                }
            }
        }
    }
    
    static func save(sleepSessions: [Date: SleepSession], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(sleepSessions)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(sleepSessions.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
