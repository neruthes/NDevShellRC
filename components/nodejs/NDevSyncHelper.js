const fs = require('fs');
const child_process = require('child_process');
const os = require('os');

var filePath = '/tmp/NDevSyncHelper-LastSyncTimestamp.txt';

var shouldSyncNow = true;

if (fs.existsSync(filePath) && fs.readFileSync(filePath).toString().trim().match(/^\d+$/)) {
    var lastSyncTimestamp = fs.readFileSync(filePath).toString();
    if (parseInt(lastSyncTimestamp) + 1000*60*15 > Date.now()) {
        // Interval: 15 min
        shouldSyncNow = false;
    };

    if (shouldSyncNow) {
        fs.writeFileSync(filePath, Date.now().toString());
        child_process.exec('NDev-Sync');
    };

    var lastSyncTimestamp2 = parseInt(fs.readFileSync(filePath).toString());
    console.log(`NDevSyncHelper: Last sync ${(new Date(lastSyncTimestamp2)).toISOString().replace('T', ' ').replace(/\.\d{3}Z$/, '')}`);

};
