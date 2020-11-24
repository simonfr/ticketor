const client = require('../config/odoo.js');

function postReports(request, h) {
    //request.payload.image
    //request.payload.subjet

    // traitement image => report

    var fakeObject = {
        name: "Voyage en Zonzonbie",
        date: '2020-11-09',
        unit_amount: 15248.65,
        quantity: 1
    }

    return new Promise((resolve, reject) => {
        client.models.methodCall('execute_kw', [
            client.getDb(), request.auth.credentials.uid, request.auth.credentials.password,
            "hr.expense", "create", [ fakeObject ]
        ], function (error, _value) {
            if(error) {
                console.log(error);
                reject(error);
            } else {
                resolve(h.response().code(201))
            }
        });
    });
}

module.exports = postReports