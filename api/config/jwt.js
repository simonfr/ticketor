const Jwt = require('@hapi/jwt');

const sharedKey = 'BRh3w!8EC3kx8r4M4K!vRWzfCNymUCtWK7a%bWHr';

function generateToken(user) {
    return Jwt.token.generate(
        {
            aud: 'urn:audience:user',
            iss: 'urn:issuer:ticketor',
            user: user
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

module.exports = { 
    generateToken: generateToken
}