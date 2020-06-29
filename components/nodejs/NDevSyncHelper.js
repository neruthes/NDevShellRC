const fs = require('fs');
const child_process = require('child_process');
const os = require('os');

var filePath = '/tmp/NDevSyncHelper-LastSyncTimestamp.txt';

var shouldSyncNow = true;

var doSyncNow = function (lastSyncTimestamp) {
    fs.writeFileSync(filePath, Date.now().toString());
    child_process.exec('bash -c "echo 123"');
    child_process.exec('bash -c "NDev-Sync"', function (err, stdin, stderr) {
        if (!err) {
            console.log(stdin);
        };
    });
    // var lastSyncTimestamp2 = parseInt(fs.readFileSync(filePath).toString());
    console.log(`NDevSyncHelper: Last sync ${(new Date(lastSyncTimestamp)).toISOString().replace('T', ' ').replace(/\.\d{3}Z$/, '')}` + ' (' + Math.floor( (Date.now()-(new Date(lastSyncTimestamp)))/1000/60 ) + ' min ago). Need to sync now.');
}

if (fs.existsSync(filePath) && fs.readFileSync(filePath).toString().trim().match(/^\d+$/)) {
    var lastSyncTimestamp = parseInt(fs.readFileSync(filePath).toString());
    if (lastSyncTimestamp + 1000*60*15 < Date.now()) {
        // Interval: 15 min
        doSyncNow(lastSyncTimestamp);
    } else {
        console.log(`NDevSyncHelper: Last sync ${
            (new Date(lastSyncTimestamp)).toISOString().replace('T', ' ').replace(/\.\d{3}Z$/, '')
        }` + ' (' + Math.floor(
                (Date.now()-(new Date(lastSyncTimestamp)))/1000/60
            ) + ' min ago). No need to sync.'
        );
    };
} else {
    // No timestamp file
    doSyncNow(0);
};
