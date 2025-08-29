@crearEstacionCliente
Feature: Crear una nueva estacion del lado cliente mediante POST /estaciones

  Background:
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * def clienteValidaRequest = read('classpath:JsonRequest/estacionClienteValidaRequest.json')
    * def camposFaltantesClienteRequest = read('classpath:JsonRequest/camposFaltantesClienteRequest.json')
    * def clusterEnCeroClienteRequest = read('classpath:JsonRequest/clusterEnCeroClienteRequest.json')
    * def errorSchema = karate.readAsString('classpath:Schema/sc_errorResponse.json')
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_crearEstacion.json')

  @ClienteValida
  Scenario: Crear estacion cliente con datos validos
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
    And print 'Estacion cliente creada exitosamente:', response
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
    And print 'Error validacion campos faltantes:', response.data.message
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

  @clusterEnCeroClienteRequest
  Scenario: El endpoint debe rechazar cuando se envia un cluster id en cero
    Given url baseUrl
    And request clusterEnCeroClienteRequest
    When method POST
    Then status 400
    And match response.success == false
    And match response.data.code == "400"
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(errorSchema, responseText)
    * match isValid == true
    And print 'Error creando estacion con cluster en 0:', response.data.message
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'