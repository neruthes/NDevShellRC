const fs = require('fs');
const child_process = require('child_process');

child_process.exec('xrandr | grep "DP1 connected" > /tmp/xrandr-dp1-connected-result.txt');
var dp1statusRaw = fs.readFileSync('/tmp/xrandr-dp1-connected-result.txt').toString();
var dp1status = dp1statusRaw.split('\n').filter(x => x.startsWith('DP1 connected'));

if (dp1status.length > 0) {
    var matchResult = dp1status[0].match(/connected (\d{3,4}x\d{3,4})/);
    if (matchResult) {
        console.log(matchResult[1]);
        child_process.exec('scrmgr-ndlt7-dual-mount-InternalImplementation ' + matchResult[1]);
        console.log(`Mounting DP1 (${matchResult[1]})...`);
    };
};
