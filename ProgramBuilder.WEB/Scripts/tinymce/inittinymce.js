tinymce.init({
    selector: 'textarea',
    height: 200,
    width: 660,
    theme: 'modern',
    resize: 'both',
    plugins: [
      'advlist autolink lists link image charmap print preview hr anchor pagebreak',
      'searchreplace wordcount visualblocks visualchars code fullscreen',
      'insertdatetime media nonbreaking save table contextmenu directionality',
      'emoticons template paste textcolor colorpicker textpattern imagetools codesample toc',
      'placeholder',
      'autoresize'
    ],
    toolbar1: 'undo redo | insert | styleselect | bold italic | underline | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
    toolbar2: 'print preview media | forecolor backcolor emoticons | codesample | sizeselect | fontselect |  fontsizeselect',
    image_advtab: true,
    templates: [
      { title: 'Test template 1', content: 'Test 1' },
      { title: 'Test template 2', content: 'Test 2' }
    ],
    content_css: [
      '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
      '//www.tinymce.com/css/codepen.min.css'
    ]

    //init_instance_callback: function (editor) {
    //    editor.on('change', function (e) {
    //        console.log('Element clicked:', e.target.nodeName);
    //        alert('change');
    //    });
    //}
});



tinymce.PluginManager.add('placeholder', function (editor) {
    editor.on('init', function () {
        var label = new Label;
        onBlur();
        tinymce.DOM.bind(label.el, 'click', onFocus);
        editor.on('focus', onFocus);
        editor.on('blur', onBlur);
        editor.on('change', onBlur);
        editor.on('setContent', onBlur);
        function onFocus() { if (!editor.settings.readonly === true) { label.hide(); } editor.execCommand('mceFocus', false); }
        function onBlur() { if (editor.getContent() == '') { label.show(); } else { label.hide(); } }
    });
    var Label = function () {
        var placeholder_text = editor.getElement().getAttribute("placeholder") || editor.settings.placeholder;
        var placeholder_attrs = editor.settings.placeholder_attrs || { style: { position: 'absolute', top: '2px', left: 0, color: '#aaaaaa', padding: '.25%', margin: '5px', width: '80%', 'font-size': '17px !important;', overflow: 'hidden', 'white-space': 'pre-wrap' } };
        var contentAreaContainer = editor.getContentAreaContainer();
        tinymce.DOM.setStyle(contentAreaContainer, 'position', 'relative');
        this.el = tinymce.DOM.add(contentAreaContainer, "label", placeholder_attrs, placeholder_text);
    }
    Label.prototype.hide = function () { tinymce.DOM.setStyle(this.el, 'display', 'none'); }
    Label.prototype.show = function () { tinymce.DOM.setStyle(this.el, 'display', ''); }
});

