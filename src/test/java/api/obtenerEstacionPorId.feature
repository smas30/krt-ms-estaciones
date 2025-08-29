@obtenerEstacionPorId
Feature: Consultar una estacion por su ID mediante el endpoint GET /estaciones/{id}

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

    # 3. EJECUTANDO SCENARIOS PARA ESTACIONES

  @obtenerPorId
  Scenario: Obtener una estacion por ID especifico y verificar que el servicio responde con status 200 y los datos de la estacion
    * def id = 20
    Given url baseUrl + '/' + id
    When method GET
    Then status 200
    And match response.success == true
    * print 'Datos obtenidos en la consulta', id, ':', response
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'
