import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    #warning("Instert your token here")
    static var token: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !token.isEmpty
        else {
            fatalError(
                """
                ⚠️ ОШИБКА: API_KEY не найден!

                ЧТО ДЕЛАТЬ:
                1. Откройте терминал в корне проекта
                2. Выполните: cp Secrets.xcconfig.template Secrets.xcconfig
                3. Откройте Secrets.xcconfig и замените "token" на реальный ключ

                ГОТОВО! Пересоберите проект.
                """
            )
        }
        return token
    }
}
