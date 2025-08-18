Feature: Servicio de autenticacion de la gerencia de soporte a la operacion

  Background:
    * url loginUrl
    * print loginUrl
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_loginToken.json')
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')

@loginToken
  Scenario: La respuesta del endpoint entrega un token JWT valido
    Given request validBodyRequest
    When method POST
    Then status 200

  # Validar que la respuesta contenga el campo token
    And match response.token == '#string'

  # Validar la estructura completa de la respuesta usando el schema JSON
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true

  # Tiempo de respuesta
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE loginToken ===', responseTime / 1000, 's'