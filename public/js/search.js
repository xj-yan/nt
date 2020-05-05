function search() {
    var query = document.getElementById('user-input').value;
    console.log(query);
    console.log("start searching");
    window.location.href = '/search?query=' + query;
}