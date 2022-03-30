import * as functions from 'firebase-functions';
import * as https from 'https';

export const oauth = functions.https.onRequest((req, res) => {

    if (req.query.code != null) {
        let str = '';
        const options = {
            hostname: 'login.salesforce.com',
            port: 443,
            path: `/services/oauth2/token?grant_type=authorization_code&redirect_uri=https://us-central1-sf-labeler.cloudfunctions.net/oauth&client_id=3MVG9riCAn8HHkYUeNXLeHjXdlW6ncpfGaKj4DNJysxBFIV.D.EavXpNaBy9MdAebmTZgqm9OkzKBC0n0HSfW&client_secret=A2961EA01CF1F6340AF13CB49121E499E6696DF54FFDE852C9E1B0CF1E0E3A3E&code=${req.query.code}`,
            method: 'GET'
        }

        const request = https.request(options, response => {
            console.log(`statusCode: ${res.statusCode}`)

            response.on('data', d => {
                str += d;
            });

            response.on('end', function () {
                const json = JSON.parse(str);
                res.status(200).send(json);
            });
        })

        request.on('error', error => {
            console.error(error)
        })

        request.end()
    }
    else {

    }

});