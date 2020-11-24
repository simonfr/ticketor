const client = require('../config/odoo.js');
const model = require('../model.js');

function getReports(request, h) {
    return new Promise((resolve, reject) => {
        client.models.methodCall('execute_kw', [
            client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
            "hr.expense", "search_read", [[['employee_id', '=', request.auth.credentials.uid]]]
        ], function (error, expenses) {
            if(error) {
                reject(error);
            } else {
                resolve(expenses.map(expense => model.fromOdoo(expense)))
            }
        });
    });
}

module.exports = getReports;