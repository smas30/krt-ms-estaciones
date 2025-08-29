@calculoIdEstacion
Feature: Obtener calculo de estacion mediante el endpoint GET /api/v1/estaciones/calculo/id

  Background:
    # 1. LLAMANDO AL SERVICIO AUTHTOKEN PARA HACER LOGIN Y OBTENER EL TOKEN
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token

    # 2. CONFIGURANDO HEADERS PARA ESTACIONES
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * print 'HEADERS usados en calculo de estacion:', headers
    * print 'TOKEN obtenido:', authToken

    # 3. DEFINIENDO PARAMETROS DE CONSULTA
    * def regionId = 1
    * def noRegionId = 5000

    # 4. CONFIGURANDO VALIDACION DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_calculoId.json')
    * def errorSchema = karate.readAsString('classpath:Schema/sc_errorResponse.json')

  @calculoId
  Scenario: Obtener calculo de estacion por region valida
    # Este escenario valida que el endpoint devuelva correctamente el calculo del id para una region
    Given url baseUrl + '/calculo/id'
    And headers headers
    And param regionId = regionId
    When method GET
    Then status 200
    And match response.success == true
    And match response.data == '#number'
    And match response.timestamp == '#number'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Calculo del Id estacion obtenido exitosamente:', response
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @regionNoExiste
  Scenario: Enviar regionId inexistente y validar respuesta
    Given url baseUrl + '/calculo/id'
    And headers headers
    And param regionId = noRegionId
    When method GET
    Then status 200
    And match response.success == false
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(errorSchema, responseText)
    * match isValid == true
    And print 'Respuesta para region inexistente:', response