//
//  FileStoreTests.swift
//  Core
//
//  Copyright © 2019 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import Core

class FileStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: FileStore().persistenceLocation(for: .surrogates))
        try? FileManager.default.removeItem(at: FileStore().persistenceLocation(for: .privacyConfiguration))
    }

    func testWhenFileExistsThenHasDataReturnsTrue() {
        let store = FileStore()
        XCTAssertFalse(store.hasData(for: .surrogates))
        
        XCTAssertNoThrow(try store.persist(Data(), for: .surrogates))
        XCTAssertTrue(store.hasData(for: .surrogates))
    }
    
    func testWhenNewThenStorageIsEmptyForConfiguration() {
        let store = FileStore()
        XCTAssertNil(store.loadAsString(for: .surrogates))
    }
    
    func testWhenDataSavedForConfigurationItCanBeLoadedAsAString() {
        let uuid = UUID().uuidString
        let data = uuid.data(using: .utf8)!
        let store = FileStore()
        XCTAssertNoThrow(try store.persist(data, for: .surrogates))
        XCTAssertEqual(uuid, store.loadAsString(for: .surrogates))
        XCTAssertNil(store.loadAsData(for: .privacyConfiguration))
    }

    private func assertDeleted(_ url: URL, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.absoluteString), file: file, line: line)
    }
    
}
