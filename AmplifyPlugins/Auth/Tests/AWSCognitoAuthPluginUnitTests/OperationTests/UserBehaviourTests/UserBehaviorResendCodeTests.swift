//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

import XCTest
@testable import Amplify
@testable import AWSCognitoAuthPlugin
import AWSCognitoIdentityProvider

class UserBehaviorResendCodeTests: BaseUserBehaviorTest {

    /// Test a successful resendConfirmationCode call with .done as next step
    ///
    /// - Given: an auth plugin with mocked service. Mocked service calls should mock a successul response
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a successful result with .email as the attribute's destination
    ///
    func testSuccessfulResendConfirmationCode() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            GetUserAttributeVerificationCodeOutputResponse(
                codeDeliveryDetails: .init(
                    attributeName: "attributeName",
                    deliveryMedium: .email,
                    destination: "destination"))
        })
        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }
            switch result {
            case .success(let attribute):
                guard case .email = attribute.destination else {
                    XCTFail("Result should be .email for attributeKey")
                    return
                }
            case .failure(let error):
                XCTFail("Received failure with error \(error)")
            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with invalid result
    ///
    /// - Given: an auth plugin with mocked service. Mocked service calls should mock a invalid response
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get an .unknown error
    ///
    func testResendConfirmationCodeWithInvalidResult() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            GetUserAttributeVerificationCodeOutputResponse()
        })
        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }
            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .unknown = error else {
                    XCTFail("Should produce an unknown error")
                    return
                }
            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with CodeMismatchException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   CodeMismatchException response
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .codeMismatch as underlyingError
    ///
    func testResendConfirmationCodeWithCodeMismatchException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.codeDeliveryFailureException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .codeDelivery = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be codeMismatch \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with InternalErrorException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a InternalErrorException response
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get an .unknown error
    ///
    func testResendConfirmationCodeWithInternalErrorException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.internalErrorException(.init())
        })
        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .unknown = error else {
                    XCTFail("Should produce an unknown error instead of \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with InvalidParameterException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   InvalidParameterException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with  .invalidParameter as underlyingError
    ///
    func testResendConfirmationCodeWithInvalidParameterException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.invalidParameterException(.init())
        })
        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .invalidParameter = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be invalidParameter \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with LimitExceededException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   LimitExceededException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .limitExceeded as underlyingError
    ///
    func testResendConfirmationCodeWithLimitExceededException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.limitExceededException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .limitExceeded = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be limitExceeded \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with NotAuthorizedException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   NotAuthorizedException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .notAuthorized error
    ///
    func testResendConfirmationCodeWithNotAuthorizedException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.notAuthorizedException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .notAuthorized = error else {
                    XCTFail("Should produce notAuthorized error instead of \(error)")
                    return
                }
            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with PasswordResetRequiredException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   PasswordResetRequiredException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .passwordResetRequired as underlyingError
    ///
    func testResendConfirmationCodeWithPasswordResetRequiredException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.passwordResetRequiredException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .passwordResetRequired = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be passwordResetRequired \(error)")
                    return
                }
            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with ResourceNotFoundException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   ResourceNotFoundException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .resourceNotFound as underlyingError
    ///
    func testResendConfirmationCodeWithResourceNotFoundException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.resourceNotFoundException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .resourceNotFound = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be resourceNotFound \(error)")
                    return
                }
            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with TooManyRequestsException response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   TooManyRequestsException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .requestLimitExceeded as underlyingError
    ///
    func testResendConfirmationCodeWithTooManyRequestsException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.tooManyRequestsException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .requestLimitExceeded = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be requestLimitExceeded \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with UserNotFound response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   UserNotConfirmedException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .userNotConfirmed as underlyingError
    ///
    func testResendConfirmationCodeWithUserNotConfirmedException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.userNotConfirmedException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .userNotConfirmed = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be userNotConfirmed \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }

    /// Test a resendConfirmationCode call with UserNotFound response from service
    ///
    /// - Given: an auth plugin with mocked service. Mocked service should mock a
    ///   UserNotFoundException response
    ///
    /// - When:
    ///    - I invoke resendConfirmationCode
    /// - Then:
    ///    - I should get a .service error with .userNotFound as underlyingError
    ///
    func testResendConfirmationCodeWithUserNotFoundException() {

        mockIdentityProvider = MockIdentityProvider(mockGetUserAttributeVerificationCodeOutputResponse: { _ in
            throw GetUserAttributeVerificationCodeOutputError.userNotFoundException(.init())
        })

        let resultExpectation = expectation(description: "Should receive a result")
        _ = plugin.resendConfirmationCode(for: .email) { result in
            defer {
                resultExpectation.fulfill()
            }

            switch result {
            case .success:
                XCTFail("Should return an error if the result from service is invalid")
            case .failure(let error):
                guard case .service(_, _, let underlyingError) = error else {
                    XCTFail("Should produce service error instead of \(error)")
                    return
                }
                guard case .userNotFound = (underlyingError as? AWSCognitoAuthError) else {
                    XCTFail("Underlying error should be userNotFound \(error)")
                    return
                }

            }
        }
        wait(for: [resultExpectation], timeout: apiTimeout)
    }
}
