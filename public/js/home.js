$(function() {
    // disable when no input
    // listen to input
    $("body").delegate(".comment", "propertychange input", function() {
        // check input
        if ($(this).val().length > 0) {
            // enable button
            $(".send").prop("disabled", false);
        } else {
            // disable button
            $(".send").prop("disabled", true);
        }
    });
    // var number = $.getCookie("pageNumber") || 1;
    var number = window.location.hash.substring(1) || 1;
    getMsgPage();

    function getMsgPage() {
        $(".page").html("");
        // tweet?act=get_page_count	get total page number
        $.ajax({
            type: "get",
            url: "/tweet",
            data: "act=get_page_count",
            success: function(msg) {
                // console.log(msg);
                var obj = eval("(" + msg + ")");
                // console.log(obj);
                for (var i = 0; i < obj; i++) {
                    // console.log(i);
                    var $a = $("<a href=\"javascript:;\">" + (i + 1) + "</a>");
                    if (i === (number - 1)) {
                        $a.addClass("cur");
                    }
                    $(".page").append($a);
                }
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
    }

    // console.log(number);
    getMsgList(number);

    function getMsgList(number) {
        $(".messageList").html("");
        $.ajax({
            type: "get",
            url: "/tweet",
            data: "act=get_follow_tweet_list&page=" + number,
            success: function(msg) {
                var obj = eval("(" + msg + ")");
                $.each(obj, function(key, value) {
                    // console.log(value);
                    // create entry
                    var $tweet = createEleRec(value);
                    $tweet.get(0).obj = value;
                    // add new tweet
                    $(".messageList").append($tweet);
                });
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
    }
    // listen to send 
    $(".send").click(function() {
        // get user input
        var $text = $(".comment").val();
        var obj = { tweet: $text };
        // // create entry
        // var $tweet = createEle($text);
        // // insert tweet
        // $(".messageList").prepend($tweet);
        $.ajax({
            type: "POST",
            url: "/tweet",
            // data: "tweet=" + $text,
            dataType: 'json',
            contentType: "application/json",
            data: JSON.stringify(obj),
            success: function(msg) {
                // var obj = eval("(" + msg + ")");
                // obj.content = $text;
                // console.log(obj);
                // create entry
                var $tweet = createEle($text);
                // $tweet.get(0).obj = obj;
                // insert tweet
                $(".messageList").prepend($tweet);
                // clear input box
                $(".comment").val("");
                // get new page count
                getMsgPage();
                // delete the oldeest tweet
                if ($(".info").length > 10) {
                    $(".info:last-child").remove();
                }
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
    });
    // listen to click on next page
    $("body").delegate(".page>a", "click", function() {
        $(this).addClass("cur");
        $(this).siblings().removeClass("cur");
        // console.log($(this).html());
        getMsgList($(this).html());
        // save hit page
        // $.addCookie("pageNumber", $(this).html());
        window.location.hash = $(this).html();
    });
    // create new entry
    function createEle(text) {
        // console.log(text)
        var $tweet = $("<div class=\"info\">\n" +
            "            <p class=\"infoText\">" + getUser() + "</p>\n" +
            "            <p class=\"infoText\">" + text + "</p>\n" +
            "            <p class=\"infoOperation\">\n" +
            "                <span class=\"infoTime\">" + formartDate() + "</span>\n" +
            "            </p>\n" +
            "        </div>");
        return $tweet;
    }

    // create new entry
    function createEleRec(text) {
        // console.log(text)
        var $tweet = $("<div class=\"info\">\n" +
            "            <p class=\"infoText\">" + text[0] + "</p>\n" +
            "            <p class=\"infoText\">" + text[1] + "</p>\n" +
            "            <p class=\"infoOperation\">\n" +
            "                <span class=\"infoTime\">" + text[2] + "</span>\n" +
            "            </p>\n" +
            "        </div>");
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

    // get user
    function getUser() {
        // api/?act=get_home_user	get username
        $.ajax({
            type: "get",
            url: "/api/name",
            data: "act=get_home_user",
            dataType: html,
            success: function(msg) {
                // console.log(msg);
                // var obj = eval("(" + msg + ")");
                return msg;
            },
            error: function(xhr) {
                alert(xhr.status);
            }
        });
    }

});