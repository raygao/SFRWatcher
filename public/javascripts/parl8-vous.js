/*
 * Used by the 'add-comment-control' in 'shared/add_comment.dryml'
 */
jQuery.fn.toggleComment = function(target, control) {
    jQuery(target).toggle("fast");
    //alert('control text -> ' + jQuery(control).text());
    if (jQuery(control).text() == "Add Comment") {
        //alert('changing to Comment-off');
        jQuery(control).text('Comment - off');
    }
    else {
        //alert('changing to Add Comment');
        jQuery(control).text('Add Comment');
    }
}

/*
 * Used by the 'add-comment' input box.
 * url -> where the post is sent
 * form -> form data to be sent
 * callback_div -> which div to update after a successful response
 *
 */
jQuery.fn.postComment = function(url, form, callback_div)  {
    //alert('form -> ' + form)
    
    var targetid = form.attr('targetid').value;
    update_div = '#'+targetid;
    control_div = "#add_comment_control_" + targetid;
    jQuery(control_div + " > a").text('Processing ...');
    jQuery(update_div).toggle("fast");
    // alert("value of targetid => " + targetid);

    jQuery.post(
        url,
        jQuery(form).serialize(),
        function(data) {
            //alert('returned data is: -> ' + data);
            jQuery(callback_div).append(data);
            jQuery(control_div + " > a").text('Add Comment');
        },
        "html"
        );
}

/*
 * Used by the 'add-comment' in 'shared/add_comment.dryml'
 * Used by 'new-feedpost' in 'new_feedpost.dryml'
 */
function checkclear(input_box){
    if(!input_box._haschanged){
        input_box.value=''
        input_box._haschanged=true
    };
}
function checkonblur(input_box, default_value) {
    if (input_box.value == "") {
        input_box.value=default_value
        input_box._haschanged=false
    }
}


/*
 * Used to follow and unfollow Entity
 */
jQuery.fn.toggleFolloButton = function(action, target_id, callback)  {
    if (action == 'Ignore') {
        url = '/Salesforce_Objects/ignore_object/' + target_id
    } else if (action == 'Observe') {
        url = '/Salesforce_Objects/observe_object/' + target_id
    }
    callback.text('Processing ...');
    jQuery.get(
        url,
        function(data) {
            callback.text(data);
            url = '';
        }
    )
}