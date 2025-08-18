@crearEstacion
Feature: Crear una nueva estacion mediante el endpoint POST /estaciones

  Background:
    # 1. LLAMANDO AL SERVICIO AUTHTOKEN PARA HACER LOGIN Y OBTENER EL TOKEN
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token

    # 2. CONFIGURANDO HEADERS PARA ESTACIONES
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * print 'HEADERS usados en creacion de estacion:', headers
    * print 'TOKEN obtenido:', authToken

    # 3. CARGANDO (REQUEST) CON DATOS DE PRUEBA
    * def estacionValidaRequest = read('classpath:JsonRequest/estacionValidaRequest.json')
    * def duplicadoCodigoRequest = read('classpath:JsonRequest/duplicadoCodigoRequest.json')
    * def camposFaltantesRequest = read('classpath:JsonRequest/camposFaltantesRequest.json')

    # 4. CONFIGURANDO VALIDACION DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_crearEstacion.json')
    * def errorSchema = karate.readAsString('classpath:Schema/sc_errorResponse.json')

  @estacionValida
  Scenario: Crear estacion con datos validos
    # Este escenario valida que el endpoint cree correctamente una estacion con datos completos y correctos
    Given url baseUrl
    And request estacionValidaRequest
    When method POST
    Then status 200
    And match response.success == true
    And match response.data.codigo == estacionValidaRequest.codigo
    And match response.data.nombre == estacionValidaRequest.nombre
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Estacion creada exitosamente:', response
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @estacionCamposFaltantes
  Scenario: El endpoint debe rechazar cuando se envian campos obligatorios vacios o nulos
    # Este escenario usa un request con campos faltantes como codigo, nombre y direccion
    Given url baseUrl
    And request camposFaltantesRequest
    When method POST
    Then status 400
    And match response.success == false
    And match response.data.code == "400"
    And match response.data.status == "BAD_REQUEST"
    And match response.data.message contains "must not be null"
    And match response.data.message contains "must not be empty"
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(errorSchema, responseText)
    * match isValid == true
    And print 'Error de validacion de campos faltantes:', response.data.message
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @estacionCodigoDuplicado
  Scenario: El endpoint debe rechazar cuando se envia un codigo de estacion ya existente
    # Este escenario usa el mismo codigo que una estacion ya registrada para simular duplicidad
    Given url baseUrl
    And request duplicadoCodigoRequest
    When method POST
    Then status 409
    And match response.success == false
    And match response.data.code == "409"
    And match response.data.message contains 'Codigo ya registrado'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(errorSchema, responseText)
    * match isValid == true
    And print 'Error por codigo duplicado:', response.data.message
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'
