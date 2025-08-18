@actualizarEstacion
Feature: Actualizar una estacion mediante el endpoint PUT /api/v1/estaciones/{id}

  Background:
    # 1. LLAMANDO AL SERVICIO AUTHTOKEN PARA HACER LOGIN Y OBTENER EL TOKEN
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token

    # 2. CONFIGURANDO HEADERS PARA ESTACIONES
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * print 'TOKEN obtenido:', authToken

    # 3. CARGANDO REQUEST DE PRUEBA
    * def estacionActualizadaRequest = read('classpath:JsonRequest/actualizarEstacionRequest.json')
    * def estacionId = 27835

    # 4. CONFIGURANDO VALIDACION DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_crearEstacion.json')

  @actualizarEstacionValida
  Scenario: Actualizar estacion con datos validos
    # Este escenario valida que el endpoint actualice correctamente una estación existente
    Given url baseUrl + '/' + estacionId
    And request estacionActualizadaRequest
    When method PUT
    Then status 200
    And match response.success == true
    And match response.data.codigo == estacionActualizadaRequest.codigo
    And match response.data.nombre == estacionActualizadaRequest.nombre
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Estación actualizada exitosamente:', response
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'
