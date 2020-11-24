const Jwt = require('@hapi/jwt');

const sharedKey = 'BRh3w!8EC3kx8r4M4K!vRWzfCNymUCtWK7a%bWHr';

function generateToken(uid, password) {
    return Jwt.token.generate(
        {
            uid: uid,
            password: password
        },
        {
            key: sharedKey,
            algorithm: 'HS512'
        },
        {
            ttlSec: 14400 // 4 hours
        }
    );
}

async function registerAuthStrategy(server) {
    await server.register(Jwt);

    server.auth.strategy('my_jwt_stategy', 'jwt', {
        keys: sharedKey,
        verify: {
            aud: false,
            iss: false,
            sub: false
        },
        validate: (artifacts, request, h) => {
            return {
                isValid: true,
                credentials: { 
                    uid: artifacts.decoded.payload.uid,
                    password: artifacts.decoded.payload.password
                }
            };
        }
    });

    server.auth.default('my_jwt_stategy');
}



module.exports = { 
    generateToken: generateToken,
    registerAuthStrategy: registerAuthStrategy
}