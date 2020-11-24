'use strict';

const Jwt = require('@hapi/jwt');
const Hapi = require('@hapi/hapi');

const signIn = require('./handlers/signIn.js');

const init = async () => {

    const server = Hapi.server({
        port: 3000,
        host: 'localhost'
    });

    await server.register(Jwt);

    server.auth.strategy('my_jwt_stategy', 'jwt', {
        keys: '',
        verify: false,
        validate: (artifacts, request, h) => {
            return {
                isValid: true,
                credentials: { user: artifacts.decoded.payload.user }
            };
        }
    });

    server.auth.default('my_jwt_stategy');

    server.route({
        method: 'POST',
        path: '/signin',
        options: {
            auth: false
        },
        handler: signIn
    });

    server.route({
        method: 'GET',
        path: '/reports',
        handler: (request, h) => {

            return 'Récupérer notes de frais';
        }
    });

    server.route({
        method: 'POST',
        path: '/reports',
        handler: (request, h) => {
            return 'Créer note de frais';
        }
    });

    await server.start();
    console.log('Server running on %s', server.info.uri);
};

process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});

init();
