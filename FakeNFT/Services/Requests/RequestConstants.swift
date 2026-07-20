import Foundation

#warning("Insert your API token into Secrets.xcconfig before building")
enum RequestConstants {
    static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""

    static var token: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TOKEN") as? String, !token.isEmpty
        else {
            fatalError(
                """
                ⚠️ ОШИБКА: TOKEN не найден!

                ЧТО ДЕЛАТЬ:
                1. Создайте файл ServerVariables.xcconfig на основе ServerVariablesPublic.xcconfig
                2. Добавьте свой токен в конфигурационный файл
                3. Пересоберите проект
                """
            )
        }
        return token
    }
}
