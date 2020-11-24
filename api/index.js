'use strict';

const Hapi = require('@hapi/hapi');

const jwt = require('./config/jwt.js');

const signIn = require('./handlers/signIn.js');
const getReports = require('./handlers/getReports.js');
const postReports = require('./handlers/postReports.js');

const init = async () => {

    const server = Hapi.server({
        port: 3000,
        host: 'localhost'
    });

    await jwt.registerAuthStrategy(server);

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
        handler: getReports
    });

    server.route({
        method: 'POST',
        path: '/reports',
        handler: postReports
    });

    await server.start();
    console.log('Server running on %s', server.info.uri);
};

process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});

init();
