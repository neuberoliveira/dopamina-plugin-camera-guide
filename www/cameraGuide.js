var cgPlugin = window.cameraGuide = function(options, success, error) {
    cordova.exec(success, error, "cameraGuide", "start", [options.url, options.width, options.height]);
};

module.exports = cgPlugin;
