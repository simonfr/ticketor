const client = require('../config/odoo.js');
const model = require('../model.js');

function getReports(request, h) {
    if(request.params.id) {
        return new Promise((resolve, reject) => {
            client.models.methodCall('execute_kw', [
                client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
                "hr.expense", "search_read", [[['employee_id', '=', request.auth.credentials.uid], ['id', '=', request.params.id]]]
            ], function (error, expenses) {
                if(error) {
                    reject(error);
                } else {
                    if (expenses.length > 0) {
                        var expense = model.fromOdoo(expenses[0]);

                        if(expenses[0].message_main_attachment_id.length > 0) {
                            client.models.methodCall('execute_kw', [
                                client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
                                "ir.attachment", "search_read", [[['id', '=', expenses[0].message_main_attachment_id[0]]]]
                            ], function (error, attachment) {
                                if (error) {
                                    reject(error);
                                } else {
                                    expense.attachment = attachment[0].datas;
                                    resolve(expense);
                                }
                            });
                        } else {
                            resolve(expense);
                        }
                    } else {
                        resolve(null);
                    }
                }
            });
        });
    } else {
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
}

module.exports = getReports;