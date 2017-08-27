//
// DetalhamentoExtrato.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class DetalhamentoExtrato: JSONEncodable {
    /** Data e hora da transação do cartão. (DD/MM/YYYY HH:mm:SS) */
    public var dataHora: String?
    /** Estabelecimento onde ocorreu a transação do cartão. */
    public var estabelecimento: String?
    /** Tipo da transação do cartão. */
    public var tipo: String?
    /** Valor monetário  da transação do cartão. */
    public var valor: Double?

    public init() {}

    // MARK: JSONEncodable
    func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["dataHora"] = self.dataHora
        nillableDictionary["estabelecimento"] = self.estabelecimento
        nillableDictionary["tipo"] = self.tipo
        nillableDictionary["valor"] = self.valor
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
