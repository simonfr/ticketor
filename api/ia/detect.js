const fs = require('fs');
const vision = require('@google-cloud/vision');
const { promises } = require('dns');

function detectText(imageBase64) {
    process.env.GOOGLE_APPLICATION_CREDENTIALS = './ia/Ticketor_credentials.json';

    const client = new vision.ImageAnnotatorClient();

    return new Promise((resolve, reject) => {
        client
        .textDetection({ image: { content: imageBase64 } })
        .then(response => {
            if(response.length > 0 && response[0].fullTextAnnotation != null) {
                const partition = response[0].fullTextAnnotation.text.split('\n');

                const result = {};

                // Recuperation du nom de l'enseigne
                result.name = partition[0];

                // Recuperation de la date
                searchDateInText(response[0].fullTextAnnotation.text)
                    .then((response) => {
                        result.date = response;
                    })

                // Récupération du total
                getTotal(response[0].fullTextAnnotation.text)
                    .then(total => {
                        result.total = total;
                    })

                resolve(result);
            } else {
                reject();
            }
        })
        .catch(err => {
            reject(err);
        });
    })
}

function searchDateInText(text) {
    return new Promise((resolve, reject) => {
        [
            /\d+\/\d+\/\d+/,
            /\d{1,2}(\.|-)\d{1,2}(\.|-)\d{4}/, 
            /\d{4}-\d{1,2}-\d{1,2}/, 
            /[0-9]{2}-[A-z]{3}-[0-9]{4}/,
            /(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|May|June|July|August|September|October|November|December)\s?[0-9]{1,2},?\s?[0-9]{2,4}/,
            /[A-z]{3}[0-9]{2}\'\s?[0-9]{2}/,
            /(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{2}/,
            /[0-9]{1,2}(\s|-)(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(\s|-|.)[0-9]{2,4}/,
            /[0-9]{2}[A-z]{3}\'\s?[0-9]{2}/
        ].forEach(regex => {
            const match = regex.exec(text);

            if (match != null && match.length > 0) {
                resolve(Date.parse(match[0]))
            }
        });
        reject();
    })
}

function getTotal(text) {
    return new Promise((resolve, reject) => {
        const x = text.toLowerCase().split("total")
        const result = /\d+[.,]\d+\n/.exec(x[x.length - 1])
        let maxNb = 0.0
        result.forEach(rb => {
            let nb = parseFloat(rb)
            if (nb > maxNb) {
                maxNb = nb
            }
        })
        resolve(maxNb)
    });
}

module.exports = detectText;