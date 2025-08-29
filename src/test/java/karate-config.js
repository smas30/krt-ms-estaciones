function fn() {
    var env = karate.env || 'dev';
    var baseUrl = '';
    var loginUrl = 'http://ms-auth-oss-git-dev-front-oss.apps.tmve-nprod-1.tmve-qa.com/intraLogin';

    if (env === 'dev') {
        baseUrl = 'http://estaciones-bff-git-dev-front-oss.apps.tmve-nprod-1.tmve-qa.com/api/v1/estaciones/';
    } else if (env === 'e2e') {
        baseUrl = 'http://examples.com';
    }

    // Headers para estaciones
    var headersEstacionesConToken = function(authToken) {
        return {
            'Content-Type': 'application/json',
            'X-USER-ID': 'E11011',
            'X-CORRELATION-ID': '1445|E11011|234234',
            'X-TOKEN-ID': authToken
        };
    };

    // Headers alternativos sin correlation ID para debugging
    var headersEstacionesSinCorrelation = function(authToken) {
        return {
            'Content-Type': 'application/json',
            'X-USER-ID': 'E11011',
            'X-TOKEN-ID': authToken
        };
    };

    return {
        env: env,
        baseUrl: baseUrl,
        loginUrl: loginUrl,
        headersEstacionesConToken: headersEstacionesConToken,
        headersEstacionesSinCorrelation: headersEstacionesSinCorrelation,
        readTimeout: 30000,
        connectTimeout: 10000
    };
}
