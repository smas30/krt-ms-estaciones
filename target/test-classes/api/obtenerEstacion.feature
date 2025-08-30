@obtenerEstaciones
Feature: Obtener estaciones mediante el endpoint GET /api/v1/estaciones

  Background:
     # 1. LLAMANDO AL SERVICIO AUTHTOKEN PARA HACER LOGIN Y OBTENER EL TOKEN
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def loginBody = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: loginBody }
    * def authToken = loginResponse.response.token
    # 2. CONFIGURANDO HEADERS PARA ESTACIONES
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * print 'HEADERS usados en creacion de estacion:', headers
    * print 'TOKEN obtenido:', authToken

  @obtenerEstacion
  Scenario: Obtener todas las estaciones sin filtros
    Given url baseUrl
    And param limit = 100
    When method GET
    Then status 200
    And match response.success == true
    And match response.data.data == '#array'
    And print 'Total de estaciones encontradas:', response.data.data.length
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @obtenerEstacionPorCodigo
  Scenario: Obtener estaciones por codigo
    Given url baseUrl
    And param codigo = 'cod600'
    When method GET
    Then status 200
    And match response.success == true
    And print 'Estacion encontrada:', response.data.data[0]
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'

  @paginacionEstaciones
  Scenario: Validar paginacion usando limit y page en GET de estaciones
  # Pagina 1
    Given url baseUrl
    And param limit = 100
    And param page = 6
    When method GET
    Then status 200
    And match response.success == true
    * def paginaUno = response.data.data
    * print 'Pagina 1:', karate.pretty(paginaUno)
  # Pagina 2
    Given url baseUrl
    And param limit = 5
    And param page = 3
    When method GET
    Then status 200
    And match response.success == true
    * def paginaDos = response.data.data
    * print 'Pagina 2:', karate.pretty(paginaDos)

  # Validar que los elementos de las paginas no se repiten
    * def codigosUno = paginaUno.map(x => x.codigo)
    * def codigosDos = paginaDos.map(x => x.codigo)
    * match codigosUno != codigosDos

