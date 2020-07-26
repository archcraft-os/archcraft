

// Place any jQuery/helper plugins in here.
jQuery.noConflict()(function($) {
    "use strict";

    $(document).ready(function() {

        $('.owl-carousel').owlCarousel({
            loop:true,
            margin:10,
            responsiveClass:true,
            responsive:{
                0:{
                    items:1,
                    nav:true
                },
                600:{
                    items:1,
                    nav:false
                },
                1000:{
                    items:4,
                    nav:true,
                    loop:false
                }
            }
        })

        /* ---------------------------------------------------------------------- */
        /*  ------------------------------- Loading ----------------------------- */
        /* ---------------------------------------------------------------------- */

        /*Page Preloading*/
        $(window).load(function() {
            $('.preloader').fadeOut();
        });

        
        /* ---------------------------------------------------------------------- */
        /* ---------------------- redimensionnement ----------------------------- */
        /* ---------------------------------------------------------------------- */

        function redimensionnement() {

            if (window.matchMedia("(max-width: 768px)").matches) {
                $('.VerticalTab_hash_scroll .resp-tabs-container').removeClass('tabs_scroll');
                $(".VerticalTab_hash_scroll .tabs_scroll").niceScroll().remove();
            } else {
                $('.VerticalTab_hash_scroll .resp-tabs-container').addClass('tabs_scroll');
                $(".VerticalTab_hash_scroll .tabs_scroll").getNiceScroll().resize();
            }

        }

        // On lie l'événement resize à la fonction
        window.addEventListener('load', redimensionnement, false);
        window.addEventListener('resize', redimensionnement, false);
    
        
       /* ---------------------------------------------------------------------- */
       /*   ------------------------- Horizontal Tab --------------------------- */
       /* ---------------------------------------------------------------------- */
       
        $('.HorizontalTab').easyResponsiveTabs({
            type: 'default', //Types: default, vertical, accordion
            width: 'auto', //auto or any width like 600px
            fit: true, // 100% fit in a container
            tabidentify: 'hor_1', // The tab groups identifier
            active_Hash: false,// activate hash
            activate: function(event) { // Callback function if tab is switched
                var $tab = $(this);
                var $info = $('#nested-tabInfo');
                var $name = $('span', $info);
                $name.text($tab.text());
                $info.show();
            }
        });
        
        
        /* ---------------------------------------------------------------------- */
        /* ------------------------- Effect tabs -------------------------------- */
        /* ---------------------------------------------------------------------- */

        var animation_style_1 = 'bounceIn';
        
        $('.HorizontalTab_1 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.HorizontalTab_1 .resp-tabs-container').addClass('animated ' + animation_style_1);
            $('.HorizontalTab_1 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.HorizontalTab_1 .resp-tabs-container').removeClass('animated ' + animation_style_1);
            });


            return false;
        });
        
        var animation_style_2 = 'fadeInLeft';
        
        $('.HorizontalTab_2 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.HorizontalTab_2 .resp-tabs-container').addClass('animated ' + animation_style_2);
            $('.HorizontalTab_2 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.HorizontalTab_2 .resp-tabs-container').removeClass('animated ' + animation_style_2);
            });


            return false;
        });
        
        var animation_style_3 = 'fadeInUp';
        
        $('.HorizontalTab_3 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.HorizontalTab_3 .resp-tabs-container').addClass('animated ' + animation_style_3);
            $('.HorizontalTab_3 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.HorizontalTab_3 .resp-tabs-container').removeClass('animated ' + animation_style_3);
            });


            return false;
        });
        
        var animation_style_4 = 'fadeIn';
        
        $('.HorizontalTab_4 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.HorizontalTab_4 .resp-tabs-container').addClass('animated ' + animation_style_4);
            $('.HorizontalTab_4 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.HorizontalTab_4 .resp-tabs-container').removeClass('animated ' + animation_style_4);
            });


            return false;
        });
        
        var animation_style_5 = 'fadeInDown';
        
        $('.HorizontalTab_5 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.HorizontalTab_5 .resp-tabs-container').addClass('animated ' + animation_style_5);
            $('.HorizontalTab_5 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.HorizontalTab_5 .resp-tabs-container').removeClass('animated ' + animation_style_5);
            });


            return false;
        });


        
        /* ---------------------------------------------------------------------- */
        /*  --------------------------- Vertical Tab ---------------------------- */
        /* ---------------------------------------------------------------------- */    

        $('.fc_VerticalTab').easyResponsiveTabs({
            type: 'vertical', //Types: default, vertical, accordion
            width: 'auto', //auto or any width like 600px
            fit: true, // 100% fit in a container
            closed: '', // accordion or '' Start closed if in accordion view
            tabidentify: 'hor_1', // The tab groups identifier
            active_Hash: false,// activate hash
            activate: function(event) { // Callback function if tab is switched
                var $tab = $(this);
                var $info = $('#nested-tabInfo2');
                var $name = $('span', $info);
                $name.text($tab.text());
                $info.show();
            }
        });
        
        $('.VerticalTab_6').easyResponsiveTabs({
            type: 'vertical', //Types: default, vertical, accordion
            width: 'auto', //auto or any width like 600px
            fit: true, // 100% fit in a container
            closed: '', // accordion or '' Start closed if in accordion view
            tabidentify: 'hor_1', // The tab groups identifier
            active_Hash: true,// activate hash
            activate: function(event) { // Callback function if tab is switched
                var $tab = $(this);
                var $info = $('#nested-tabInfo3');
                var $name = $('span', $info);
                $name.text($tab.text());
                $info.show();
            }
        });
            
        /* ---------------------------------------------------------------------- */
        /* ------------------------- Effect tabs -------------------------------- */
        /* ---------------------------------------------------------------------- */

        var animation_style_1 = 'bounceIn';
        
        $('.VerticalTab_1 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.VerticalTab_1 .resp-tabs-container').addClass('animated ' + animation_style_1);
            $('.VerticalTab_1 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.VerticalTab_1 .resp-tabs-container').removeClass('animated ' + animation_style_1);
            });


            return false;
        });
        
        var animation_style_2 = 'bounceIn';
        
        $('.VerticalTab_2 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.VerticalTab_2 .resp-tabs-container').addClass('animated ' + animation_style_2);
            $('.VerticalTab_2 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.VerticalTab_2 .resp-tabs-container').removeClass('animated ' + animation_style_2);
            });


            return false;
        });
        
        var animation_style_3 = 'bounceIn';
        
        $('.VerticalTab_3 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.VerticalTab_3 .resp-tabs-container').addClass('animated ' + animation_style_3);
            $('.VerticalTab_3 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.VerticalTab_3 .resp-tabs-container').removeClass('animated ' + animation_style_3);
            });


            return false;
        });
        
        var animation_style_4 = 'bounceIn';
        
        $('.VerticalTab_4 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.VerticalTab_4 .resp-tabs-container').addClass('animated ' + animation_style_4);
            $('.VerticalTab_4 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.VerticalTab_4 .resp-tabs-container').removeClass('animated ' + animation_style_4);
            });


            return false;
        });
        
        
        var animation_style_5 = 'bounceIn';
        
        $('.VerticalTab_5 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.VerticalTab_5 .resp-tabs-container').addClass('animated ' + animation_style_5);
            $('.VerticalTab_5 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.VerticalTab_5 .resp-tabs-container').removeClass('animated ' + animation_style_5);
            });


            return false;
        });
        
        var animation_style_6 = 'fadeIn';
        
        $('.VerticalTab_6 ul.resp-tabs-list li[class^=tabs-]').click(function() {

            $('.VerticalTab_6 .resp-tabs-container').addClass('animated ' + animation_style_6);
            $('.VerticalTab_6 .resp-tabs-container').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
                $('.VerticalTab_6 .resp-tabs-container').removeClass('animated ' + animation_style_6);
            });


            return false;
        });
        
        
        /* ---------------------------------------------------------------------- */
        /* ---------------------------- icon menu ------------------------------- */
        /* ---------------------------------------------------------------------- */

        $(".resp-tabs-container h2.resp-accordion").each(function() {

            if ($(this).hasClass('resp-tab-active')) {
                $(this).append("<i class='fa fa-angle-up arrow-tabs'></i>");
            } else {
                $(this).append("<i class='fa fa-angle-down arrow-tabs'></i>");
            }
        });

        $(".resp-tabs-container h2.resp-accordion").click(function() {
            if ($(this).hasClass('resp-tab-active')) {
                $(this).find("i.arrow-tabs").removeClass("fa-angle-down").addClass("fa-angle-up");
            }

            $(".resp-tabs-container h2.resp-accordion").each(function() {

                if (!$(this).hasClass('resp-tab-active')) {
                    $(this).find("i.arrow-tabs").removeClass("fa-angle-up").addClass("fa-angle-down");
                }
            });


    });
       
       
       

    }); // close


}); // close