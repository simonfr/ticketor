
const client = require('../config/odoo.js');
const jwt = require('../config/jwt.js');

function signIn(request, h) {
    return new Promise((resolve, reject) => {
        client.methodCall('authenticate', [
            'odoo', request.payload.login, request.payload.password, {}
        ], function (error, value) {
            if (value) {
                const token = jwt.generateToken(request.payload.login);
                resolve(h.response(token).code(200));
            } else {
                resolve(h.response('Bad credentials').code(401));
            }

            if (error) {
                reject(error);
            }
        })
    });
}

module.exports = signIn;