import Foundation

// MARK: - Protocol

protocol ProfileEditPresenter {
    func viewDidLoad()
    func didChangeName(_ name: String)
    func didChangeDescription(_ description: String)
    func didChangeWebsite(_ website: String)
    func didTapChangePhoto()
    func didSelectChangePhoto()
    func didSelectDeletePhoto()
    func didEnterAvatarURL(_ urlString: String)
    func didTapSave()
    func didTapClose()
    func didConfirmExit()
}

// MARK: - State

enum ProfileEditState {
    case editing
    case saving
    case saved(Profile)
    case failed(Error)
}

final class ProfileEditPresenterImpl: ProfileEditPresenter {

    // MARK: - Properties

    weak var view: ProfileEditView?
    var onProfileUpdated: ((Profile) -> Void)?

    private let profileId: String
    private let service: ProfileService
    private let initialForm: ProfileEditForm
    private var form: ProfileEditForm
    private var state = ProfileEditState.editing {
        didSet {
            stateDidChanged()
        }
    }

    private var hasChanges: Bool {
        form.name != initialForm.name
            || form.description != initialForm.description
            || form.website != initialForm.website
            || form.avatar != initialForm.avatar
    }

    // MARK: - Init

    init(profileId: String, profile: Profile, service: ProfileService) {
        self.profileId = profileId
        self.service = service
        self.initialForm = ProfileEditForm(profile: profile)
        self.form = ProfileEditForm(profile: profile)
    }

    // MARK: - ProfileEditPresenter

    func viewDidLoad() {
        view?.fillForm(makeFormViewModel())
    }

    func didChangeName(_ name: String) {
        form.name = name
    }

    func didChangeDescription(_ description: String) {
        form.description = description
    }

    func didChangeWebsite(_ website: String) {
        form.website = website
    }

    func didTapChangePhoto() {
        view?.showPhotoOptions()
    }

    func didSelectChangePhoto() {
        view?.showAvatarURLInput(currentURL: form.avatar)
    }

    func didSelectDeletePhoto() {
        form.avatar = ""
        view?.updateAvatar(nil)
    }

    func didEnterAvatarURL(_ urlString: String) {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        form.avatar = trimmed
        view?.updateAvatar(URL(string: trimmed))
    }

    func didTapSave() {
        state = .saving
    }

    func didTapClose() {
        if hasChanges {
            view?.showExitConfirmation()
        } else {
            view?.closeScreen()
        }
    }

    func didConfirmExit() {
        view?.closeScreen()
    }

    // MARK: - Private

    private func stateDidChanged() {
        switch state {
        case .editing:
            break
        case .saving:
            view?.setUserInteractionEnabled(false)
            view?.showLoading()
            save()
        case .saved(let profile):
            view?.hideLoading()
            view?.setUserInteractionEnabled(true)
            onProfileUpdated?(profile)
            view?.closeScreen()
        case .failed(let error):
            view?.hideLoading()
            view?.setUserInteractionEnabled(true)
            view?.showError(makeErrorModel(error))
        }
    }

    private func save() {
        service.updateProfile(id: profileId, dto: form.makeDto()) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.state = .saved(profile)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func makeFormViewModel() -> ProfileEditFormViewModel {
        ProfileEditFormViewModel(
            avatarURL: URL(string: form.avatar),
            name: form.name,
            description: form.description,
            website: form.website
        )
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .saving
        }
    }
}
