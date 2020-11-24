
const client = require('../config/odoo.js');
const jwt = require('../config/jwt.js');

function signIn(request, h) {
    return new Promise((resolve, reject) => {
        client.common.methodCall('authenticate', [
            client.getDb(), request.payload.login, request.payload.password, {}
        ], function (error, uid) {
            if (uid) {
                const token = jwt.generateToken(uid, request.payload.password);
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