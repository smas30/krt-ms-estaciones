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

  @descargarExcelEstaciones
  Scenario: El endpoint debe permitir descargar el archivo Excel con las estaciones registradas
    Given url baseUrl + '/export'
    And headers headers
    When method POST
    Then status 200
    And match header Content-Type contains 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

    # === Extracción del nombre y tamaño del archivo ===
    * def contentDisposition = responseHeaders['content-disposition'][0]
    * def fileName = contentDisposition.split('filename=')[1]
    * def fileSize = responseHeaders['content-length'] || 'desconocido'

    # === Validaciones e impresión ===
    And print '✅ Nombre del archivo exportado:', fileName
    And print '📦 Tamaño del archivo:', fileSize, 'bytes'
    And print '⏱ Tiempo de respuesta:', responseTime / 1000, 'segundos'
