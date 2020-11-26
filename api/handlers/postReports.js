const client = require('../config/odoo.js');
const detectText = require('../ia/detect.js');
var moment = require('moment');

function postReports(request, h) {
    //request.payload.image
    //request.payload.subjet
    return new Promise((resolve, reject) => {
    // traitement image => report
        detectText(Buffer.from(request.payload.images))
        .then((response) => {
            if (!response.name) {
                resolve(h.response("cannot find expense name").code(422))
            } else {
                client.models.methodCall('execute_kw', [
                    client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
                    "hr.expense", "create", [ {
                        name: response.name,
                        date: moment(response.date).format('YYYY-MM-DD'),
                        unit_amount: response.total,
                        employee_id: request.auth.credentials.uid
                    } ]
                ], function (error, value) {
                    if(error) {
                        console.log(error);
                        resolve(h.response().code(503))
                    } else {
                        createBase64Image(request, value);
                        resolve(h.response().code(201))
                    }
                });
            }
        })
        .catch(() => {
            resolve(h.response("image not readable").code(422));
        })
    });
}

function createBase64Image(request, expenseId) {
    client.models.methodCall('execute_kw', [
        client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
        "ir.attachment", "create", [ {
            res_model: 'hr.expense',
            name: 'image',
            res_id: expenseId,
            type: 'binary',
            datas: Buffer.from(request.payload.images).toString('base64')
        } ]
    ], function (error, attachmentId) {
        if(error) {
            console.log(error);
        } else {
            updateAttachment(request, attachmentId, expenseId);
        }
    });
}

function updateAttachment(request, attachmentId, expenseId) {
    client.models.methodCall('execute_kw', [
        client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
        "hr.expense", "write", [ [expenseId], {
            message_main_attachment_id: attachmentId
        } ]
    ], function (error, _value) {
        if(error) {
            console.log(error);
        }
    });
}

module.exports = postReports