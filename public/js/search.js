$(document).ready(function() {

    var userID = getUserID();

    $(".nav-bar-item-wrap").mouseenter(function() {
        $(this).css({
            "color": "rgb(29, 161, 242)",
            "background-color": "rgb(245,248,250)",
            "border-radius": "25px",
            "transition": "all 0.5s",
            "cursor": "pointer"
        });

        $(this).find("i").css({
            "color": "rgb(29, 161, 242)",
            "transition": "all 0.5s"
        });
    });

    $(".nav-bar-item-wrap").mouseleave(function() {
        $(this).css({
            "color": "black",
            "background-color": "rgba(245,248,250,0)",
            "border-radius": "25px"
        });

        $(this).find("i").css("color", "black");
    });

    $("#logout-btn").click(function() {
        window.location.href = '/logout';
    });

    $("#post-twitter").click(function() {
        window.location.href = '/';
    });

    $("#profile-btn").click(function() {
        window.location.href = '/user/' + getUserID();
    });

    // get username
    function getUser() {
        var text = ""
            // api/?act=get_home_user	get username
        $.ajax({
            type: "get",
            url: "/api/user",
            data: "act=get_home_user",
            async: false,
            dataType: "json",
            success: function(msg) {
                // var obj = eval("(" + msg + ")");
                text = msg;
                console.log(text);
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
        return text;
    }

    // get user id
    function getUserID() {
        var text = ""
            // api/?act=get_home_user	get username
        $.ajax({
            type: "get",
            url: "/api/user",
            data: "act=get_home_user_id",
            async: false,
            dataType: "json",
            success: function(msg) {
                // var obj = eval("(" + msg + ")");
                text = msg;
                // console.log(text);
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
        return text;
    }

});