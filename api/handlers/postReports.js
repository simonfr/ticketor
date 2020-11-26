const client = require('../config/odoo.js');

function postReports(request, h) {
    //request.payload.image
    //request.payload.subjet

    // traitement image => report

    var fakeObject = {
        name: "Voyage en Zonzonbie",
        date: '2020-11-09',
        unit_amount: 15248.65,
        quantity: 1,
        employee_id: request.auth.credentials.uid
    }

    return new Promise((resolve, reject) => {
        client.models.methodCall('execute_kw', [
            client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
            "hr.expense", "create", [ fakeObject ]
        ], function (error, value) {
            if(error) {
                console.log(error);
                reject(error);
            } else {
                createBase64Image(request, value);
                resolve(h.response().code(201))
            }
        });
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