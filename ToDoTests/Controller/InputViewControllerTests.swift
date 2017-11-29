//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Stefan Sut on 10/27/17.
//  Copyright © 2017 Stefan Sut. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        
        _ = sut.view
    }
    
    override func tearDown() {
        sut.itemManager?.removeAll()
        
        super.tearDown()
    }
    
    func test_hasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_hasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_hasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_hasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_hasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_hasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }
    
    func test_hasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let date = dateFormatter.date(from: "02/22/2016")!
        let timestamp = date.timeIntervalSince1970
        
        sut.titleTextField.text = "Foo"
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.locationTextField.text = "Bar"
        sut.addressTextField.text = "Infinte Loop 1, Cupertino"
        sut.descriptionTextField.text = "Baz"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.itemManager = ItemManager()
        
        sut.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        let item = sut.itemManager?.item(at: 0)
        
        let testItem = ToDoItem(title: "Foo", itemDescription: "Baz", timestamp: timestamp, location: Location(name: "Bar", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_Geocoder_FetchesCoordinates() {
        let geocoderAnswered = expectation(description: "Geocoder")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") { (placemarks, error) in
            
            let coordinate = placemarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(latitude, 37.3316, accuracy: 0.0001)
            XCTAssertEqual(longitude, -122.0300, accuracy: 0.001)
            
            geocoderAnswered.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_Save_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        
        mockInputViewController.save()
        
        XCTAssertTrue(mockInputViewController.dismissedGotCalled)
    }
    
}

extension InputViewControllerTests {
   
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override
        func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else {
                return CLLocation()
            }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    class MockInputViewController: InputViewController {
        var dismissedGotCalled = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissedGotCalled = true
        }
    }
    
}
