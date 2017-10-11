//
//  DiskPersistentHandlerTests.swift
//  StatsdClient-iOS Tests
//
//  Created by Nghia Tran on 10/9/17.
//  Copyright © 2017 StatsdClient. All rights reserved.
//

import XCTest
@testable import StatsdClient

class DiskPersistentHandlerTests: XCTestCase {

    let config = DiskConfiguration()
    let fileManager = FileManager.default
    var handler: DiskPersistentHandler!

    override func setUp() {
        super.setUp()

        handler = try? DiskPersistentHandler(config: config, hanlder: fileManager)
    }

    override func tearDown() {
        super.tearDown()

        try? handler.deleteAllFile()
    }

    func testInitialization() {
        XCTAssertNoThrow(try DiskPersistentHandler(config: DiskConfiguration()),
                         "Able to initialize DiskPersistentHandler with default configuration")
    }

    func testTotalCountAtFreshInitialization() {
        XCTAssertEqual(handler.getTotal(), 0, "File count should be 0")
    }

    func testTotalCountAfterInitializationBefore() {

        let metric = StubMetric()

        XCTAssertNoThrow(try handler.write(metric, key: metric.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertNoThrow({[unowned self] in
            let anotherHandler = try DiskPersistentHandler(config: self.config,
                                                           hanlder: self.fileManager)
            XCTAssertEqual(anotherHandler.getTotal(), 1,
                           "Another Hanlder should fetch same data if same configuration")
        }, "Initialized without exception")
    }

    func testCreateCacheFolderAfterInitalization() {
        guard let pathFolder = config.pathFolder else {
            XCTFail("Invalid Path Folder")
            return
        }
        let isExisted = fileManager.fileExists(atPath: pathFolder)
        XCTAssertTrue(isExisted,
                      "it should create cache folder which cooresponse with config's pathFolder")
    }

    func testMakePathFile() {

        let fileName = "Login_Stats"
        let filePath = handler.makeFilePath(fileName)
        guard let pathFolder = config.pathFolder else {
            XCTFail("Invalid Path Folder")
            return
        }

        let expected = "\(pathFolder)/\(fileName.toBase64())"
        XCTAssertEqual(filePath, expected, "File path should match format")
    }

    func testWriteIndividualFile() {

        let metric_1 = StubMetric()
        let metric_2 = StubMetric(name: "Aloha")

        XCTAssertNoThrow(try handler.write(metric_1, key: metric_1.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertEqual(handler.getTotal(), 1, "File count should be 1")
        XCTAssertNoThrow(try handler.write(metric_2, key: metric_2.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertEqual(handler.getTotal(), 2, "File count should be 2")

        XCTAssertTrue(fileManager.fileExists(atPath: handler.makeFilePath(metric_1.name)), "File exists")
        XCTAssertTrue(fileManager.fileExists(atPath: handler.makeFilePath(metric_2.name)), "File exists")
    }

    func testWriteManyFiles() {

        let metric = StubMetric()

        XCTAssertNoThrow(try handler.write(metric, key: metric.name,
                                           attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertTrue(fileManager.fileExists(atPath: handler.makeFilePath(metric.name)), "File exists")
    }

    func testReceivedFile() {

        let metric = StubMetric()

        XCTAssertNoThrow(try handler.write(metric, key: metric.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertNoThrow({[unowned self] in

            let receiveFile = try self.handler.get(key: metric.name, type: StubMetric.self)
            XCTAssertEqual(receiveFile, metric, "Should be equal")

            }, "Receive file success")
        XCTAssertThrowsError(try self.handler.get(key: "Wrong key", type: StubMetric.self),
                             "Should throw exception because fetching no exist file")
    }

    func testDeleteAll() {

        let metric_1 = StubMetric()
        let metric_2 = StubMetric(name: "Aloha")

        XCTAssertNoThrow(try handler.write(metric_1, key: metric_1.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertNoThrow(try handler.write(metric_2, key: metric_2.name, attribute: nil),
                         "Write fill successfully without any execptions")

        XCTAssertNoThrow(try handler.deleteAllFile(), "Delete all without any execeptions")
        XCTAssertEqual(handler.getTotal(), 0, "Should be 0")
    }

    func testGetAll() {

        let metric_1 = StubMetric()
        let metric_2 = StubMetric(name: "Aloha")

        XCTAssertNoThrow(try handler.write(metric_1, key: metric_1.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertEqual(handler.getTotal(), 1, "File count should be 1")
        XCTAssertNoThrow(try handler.write(metric_2, key: metric_2.name, attribute: nil),
                         "Write fill successfully without any execptions")
        XCTAssertEqual(handler.getTotal(), 2, "File count should be 2")

        XCTAssertNoThrow({[unowned self] in

        let items: [StubMetric] = try self.handler.getAll(type: StubMetric.self)
        XCTAssertEqual(items[0], metric_2)
        XCTAssertEqual(items[1], metric_1)

        }, "Get all files success")
    }

}
