function entersearch() {
    var event = window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == 13) {
        var query = document.getElementById('search').value;
        console.log(query);
        console.log("start searching");
        window.location.href = '/search?query=' + query;
    }
}