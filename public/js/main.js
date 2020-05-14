$(document).ready(function() {

    var userID = getUserID();
    getTweetList();

    function getTweetList() {
        $("#post-container").html("");
        $.ajax({
            type: "get",
            url: "/timeline",
            data: "act=get_home_timeline&user_id=" + userID,
            success: function(msg) {
                var obj = eval("(" + msg + ")");
                $.each(obj, function(key, value) {
                    // console.log(value);
                    // create entry
                    var $tweet = createEleRec(value);
                    console.log($tweet);
                    $tweet.get(0).obj = value;
                    // add new tweet
                    $("#post-container").append($tweet);
                });
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
    }

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



    // // listen to post-btn
    // $("#post-btn").click(function() {
    //     // get user input
    //     var $text = $("#user-input").val();
    //     var obj = {
    //         tweet: $text
    //     };
    //     $.ajax({
    //         type: "POST",
    //         url: "/tweet",
    //         // data: "tweet=" + $text,
    //         dataType: 'json',
    //         contentType: "application/json",
    //         data: JSON.stringify(obj),
    //         success: function(msg) {
    //             // console.log(obj);
    //             // create entry
    //             var $tweet = createEle($text);
    //             // $tweet.get(0).obj = obj;
    //             // insert tweet
    //             $("#post-container").prepend($tweet);
    //             // clear input box
    //             $("#user-input").val("");
    //             // get new page count
    //             // getMsgPage();
    //             // delete the oldeest tweet
    //             // if ($(".info").length > 10) {
    //             //     $(".info:last-child").remove();
    //             // }
    //         },
    //         error: function(xhr) {
    //             alert(xhr.status);
    //         }
    //     });
    // });

    // listen to post-btn
    $("#post-btn").click(function() {
        // get user input
        var $text = $("#user-input").val();
        var $tweet = createEle($text);
        $("#post-container").prepend($tweet);
        $("#user-input").val("");
        var obj = {
            tweet: $text
        };
        $.ajax({
            type: "POST",
            url: "/tweet",
            // data: "tweet=" + $text,
            dataType: 'json',
            contentType: "application/json",
            data: JSON.stringify(obj)
        });
    });

    // create new entry
    function createEleRec(text) {
        console.log(text)
        var $tweet = $("<div class=user-post id=" + "" + ">" +
            "<div class=user-post-wrap>" +
            "<img class=current-user src=" + "/images/search_user.jpg" + ">" +
            "<div class=user-post-content>" +
            "<p class=current-user-name>" +
            "<a id=post-name class=user-post-name href=/user/" + text["user_id"] + ">" + getName(text["user_id"]) + "</a>" +
            "<span class=user-post-time>" + text["created_at"] + "</span>" +
            "</p>" +
            "<p class=current-user-post>" + text["tweet"] + "</p>" +
            "</div>"
        );
        return $tweet;
    }

    // create new entry
    function createEle(text) {
        var username = getUser();
        var $tweet = $("<div class=user-post id=" + "" + ">" +
            "<div class=user-post-wrap>" +
            "<img class=current-user src=" + "/images/search_user.jpg" + ">" +
            "<div class=user-post-content>" +
            "<p class=current-user-name>" +
            "<a id=post-name class=user-post-name href=/user/" + userID + ">" + username + "</a>" +
            "<span class=user-post-time>" + formartDate() + "</span>" +
            "</p>" +
            "<p class=current-user-post>" + text + "</p>" +
            "</div>"
        );
        return $tweet;
    }

    // create date 
    function formartDate() {
        var date = new Date();
        // 2020-3-20 21:30:23
        var arr = [date.getFullYear() + "-",
            date.getMonth() + 1 + "-",
            date.getDate() + " ",
            date.getHours() + ":",
            date.getMinutes() + ":",
            date.getSeconds()
        ];
        return arr.join("");

    }

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

    // get user id
    function getName(id) {
        var text = ""
            // api/?act=get_home_user	get username
        $.ajax({
            type: "get",
            url: "/api/user",
            data: "act=get_tweet_name&user_id=" + id,
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