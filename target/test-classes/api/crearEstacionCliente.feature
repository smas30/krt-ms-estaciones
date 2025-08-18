@crearEstacionCliente
Feature: Crear una nueva estación del lado cliente mediante POST /estaciones

  Background:
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * def clienteValidaRequest = read('classpath:JsonRequest/estacionClienteValidaRequest.json')
    * def camposFaltantesClienteRequest = read('classpath:JsonRequest/camposFaltantesClienteRequest.json')
    * def duplicadoCodigoClienteRequest = read('classpath:JsonRequest/duplicadoCodigoClienteRequest.json')
    * def errorSchema = karate.readAsString('classpath:Schema/sc_errorResponse.json')
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_crearEstacion.json')

  @ClienteValida
  Scenario: Crear estación cliente con datos válidos
    Given url baseUrl
    And request clienteValidaRequest
    When method POST
    Then status 200
    And match response.success == true
    And match response.data.codigo == clienteValidaRequest.codigo
    And match response.data.nombre == clienteValidaRequest.nombre
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Estación cliente creada exitosamente:', response
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

  @ClienteCamposFaltantes
  Scenario: Rechazo por campos obligatorios faltantes
    Given url baseUrl
    And request camposFaltantesClienteRequest
    When method POST
    Then status 400
    And match response.success == false
    And match response.data.code == "400"
    * def mensaje = response.data.message
    * match mensaje == '#regex .*must not be (null|empty).*'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(errorSchema, responseText)
    * match isValid == true
    And print 'Error validación campos faltantes:', response.data.message
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

  @ClienteCodigoDuplicado
  Scenario: Rechazo por codigo duplicado
    Given url baseUrl
    And request duplicadoCodigoClienteRequest
    When method POST
    Then status 409
    And match response.success == false
    And match response.data.code == "409"
    And match response.data.message contains 'Codigo ya registrado'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(errorSchema, responseText)
    * match isValid == true
    And print 'Error por codigo duplicado:', response.data.message
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'
