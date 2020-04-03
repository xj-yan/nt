$(function() {
    // var number = $.getCookie("pageNumber") || 1;
    var number = window.location.hash.substring(1) || 1;
    getMsgPage();

    function getMsgPage() {
        $(".page").html("");
        // tweet?act=get_page_count	get total page number
        $.ajax({
            type: "get",
            url: "/tweet",
            data: "act=get_uxer_page_count",
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

});