@exportEstaciones
Feature: Exportar estaciones mediante el endpoint GET /estaciones/export

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
    * print 'TOKEN obtenido:', authToken

  @descargarExcelEstaciones
  Scenario: El endpoint debe permitir descargar el archivo Excel con las estaciones registradas
    Given url baseUrl + '/export'
    And headers headers
    ##And param page = 1
    When method POST
    Then status 200
    And match header Content-Type contains 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

    * def fileName = responseHeaders['content-disposition'] ? responseHeaders['content-disposition'].split('filename=')[1] : 'estaciones_export.xlsx'
    * def fileSize = responseHeaders['content-length'] || 'desconocido'

    # === ARCHIVO EXCEL GENERADO ===
    And print 'Nombre del archivo:', fileName
    And print 'Tamaño del archivo:', fileSize, 'bytes'
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'
