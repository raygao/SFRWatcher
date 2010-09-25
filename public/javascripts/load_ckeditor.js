HoboCKEditor = {
    newEditor : function(elm, buttons) {
        if (elm.name != '') {
            oInstance = CKEDITOR.replace( elm.name ,
                { toolbar : HoboCKEditor.standardToolbarConfig || buttons }
                );
            oInstance.setData( elm.value );
            oInstance.resetDirty();
        }
        return oInstance;
    },
    makeEditor : function(elm) {
        if (!elm.disabled && !elm.readOnly){
            HoboCKEditor.newEditor(elm);
        }
    },
    standardToolbarConfig: [ ['DocProps','-','Preview','-','Templates'],
        ['Cut','Copy','Paste','PasteText','PasteWord','-','Print','SpellCheck'],
        ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
        [],
        '/',
        ['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
        ['OrderedList','UnorderedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
        ['Link','Unlink'],
        ['Image','Rule','SpecialChar','PageBreak'],
        '/',
        ['Style','FontFormat','FontName','FontSize'],
        ['TextColor','BGColor'],
        ['FitWindow','ShowBlocks','-','About'] ]
}
Hobo.makeHtmlEditor = HoboCKEditor.makeEditor