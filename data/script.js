function playsound(table) {
    var file = table['file']
    var volume = table['volume']
    var audioPlayer = null;
    if (audioPlayer != null) {
        audioPlayer.pause();
    }
    if (volume == undefined) {
        volume = 0.2
    }
    audioPlayer = new Audio("./audio/" + file + ".ogg");
    audioPlayer.volume = volume;
    audioPlayer.play();
}

window.addEventListener('message', function(event) {
    var data = event.data;
    if (event.data.type == 'playsound') {
        playsound(event.data.content)
    }
    if (event.data.type == 'door') {
        document.getElementById('door').innerHTML = `
            <video autoplay id="myVideo">
                <source src="audio/door.mp4" type="video/mp4">
            </video>
        `
        setTimeout(function() {
            document.getElementById('door').innerHTML = ''
        }, 7000)
    }

});