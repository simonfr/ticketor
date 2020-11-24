var xmlrpc = require('xmlrpc')
 
module.exports = xmlrpc.createClient({ host: 'localhost', port: 8069, path: '/xmlrpc/2/common'});