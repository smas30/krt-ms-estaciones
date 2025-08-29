@morinre
Feature: Actualizar una estacion modificando la direccion para verificar el cambio de estado en Morinre

  Background:
    # 1. LOGIN PARA OBTENER TOKEN
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token

    # 2. CONFIGURANDO HEADERS
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * print 'HEADERS usados en actualizacion Morinre:', headers
    * print 'TOKEN obtenido:', authToken

    # 3. CARGANDO REQUEST CON CAMBIO EN DIRECCION
    * def morinreRequest = read('classpath:JsonRequest/estacionMorinreRequest.json')
    * def estacionId = 27835

    # 4. CONFIGURANDO VALIDACION DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_crearEstacion.json')

  @estacionMorinre
  Scenario: Actualizar estacion modificando la direccion para activar cambio en Morinre
    # Se cambia el numero de piso, de 1 a 5 para validar comportamiento
    Given url baseUrl + '/' + estacionId
    And request morinreRequest
    When method PUT
    Then status 200
    And match response.success == true
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Estacion actualizada para Morinre:', response.data.estacion
    And print 'Estatus Morinre actualizado:', response.data.estacion.estatusMorinre
    And print '=== TIEMPO DE RESPUESTA DEL FEATURE ===', responseTime / 1000, 's'
