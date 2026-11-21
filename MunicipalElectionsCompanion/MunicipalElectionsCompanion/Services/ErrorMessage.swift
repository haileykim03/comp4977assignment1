import Foundation
import FirebaseAuth
import FirebaseFirestore

struct InvalidFirebaseDataError: LocalizedError {
    var errorDescription: String? {
        "Some data stored in Firebase could not be read."
    }
}

enum ErrorMessage {
    static func from(_ error: Error) -> String {
        if let apiError = error as? APIError {
            return apiError.localizedDescription
        }
        if error is InvalidFirebaseDataError || error is DecodingError {
            return "Some data stored in Firebase could not be read."
        }

        let nsError = error as NSError

        if nsError.domain == FirestoreErrorDomain,
           let code = FirestoreErrorCode.Code(rawValue: nsError.code) {
            switch code {
            case .unavailable, .deadlineExceeded:
                return "Can't connect to Firebase right now. Check your internet connection and try again."
            case .permissionDenied:
                return "Firebase blocked this request. You can only access your own selections."
            case .unauthenticated:
                return "Your cloud session has expired. Please log out and log in again."
            case .dataLoss, .invalidArgument:
                return "Firebase sent data the app could not read."
            default:
                return "Firebase error: \(nsError.localizedDescription)"
            }
        }

        if nsError.domain == "FIRAuthErrorDomain",
           let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .networkError:
                return "You appear to be offline. Check your internet connection and try again."
            case .emailAlreadyInUse, .wrongPassword, .invalidCredential:
                return "This account's cloud storage uses a different password. Please contact support."
            case .tooManyRequests:
                return "Too many attempts. Please wait a moment and try again."
            case .userDisabled:
                return "This account has been disabled."
            default:
                return "Cloud sign-in failed: \(nsError.localizedDescription)"
            }
        }

        if nsError.domain == NSURLErrorDomain {
            return "A network error occurred. Check your internet connection and try again."
        }

        return error.localizedDescription
    }
}
