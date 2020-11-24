var xmlrpc = require('xmlrpc')
 
const host = process.env.ODOO_HOST || 'localhost';
const port = process.env.ODOO_PORT || 8069;

function getDb() {
    return 'odoo';
}

module.exports = {
    getDb: getDb,
    common: xmlrpc.createClient({ host: host, port: port, path: '/xmlrpc/2/common'}),
    models: xmlrpc.createClient({ host: host, port: port, path: '/xmlrpc/2/object'})
}