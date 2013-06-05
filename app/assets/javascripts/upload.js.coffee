MAX_FILES       =   500
MAX_FILE_SIZE   =   10
MIMES_ALLOWED   =   ["image/jpeg"] #'image/jpeg','image/png','image/gif'
FILES_MAP       =   {}

UPLOAD_TEMPLATE = """
<div class="media image-template">
  <div class="pull-left">
    <img class="media-object">
  </div>
  <div class="media-body">
    <h4 class="image-name"></h4>
    <div class="image-size"></div>
    <div class="toolbox">
      <span class="btn btn-primary upload"><i class="icon-upload icon-white"></i> Upload</span>
      <span class="btn btn-danger remove"><i class="icon-remove icon-white"></i> Remove</span>
      <div class="progress progress-info progress-striped active hidden">
        <div class="bar" style="width: 0%"></div>
      </div>
    </div>
  </div>
</div>
"""

create_upload_template = (file, upload) ->
  reader = new FileReader()

  tmp = $(UPLOAD_TEMPLATE)

  img = tmp.find('img')

  #reader.onload = (e) -> img.attr src: e.target.result

  #reader.readAsDataURL(file)

  tmp.find('.upload').on 'click', ->
    upload()
    tmp.find('.btn').addClass('hidden')
    tmp.find('.progress').removeClass('hidden')
  tmp.find('.remove').on 'click', ->
    tmp.remove()

  tmp.find('.image-name').text(file.name)
  tmp.find('.image-size').text( ((( file.size / (1024*1024) * 100) << 0 ) / 100) + " Mo")

  return tmp

to_json = (x) ->
  if x instanceof Array
    return "[" +
    x.map((itm) -> to_json(itm)).join(',')
    + "]"
  else if typeof x is 'object'
    return "{" + (for k,v of x when typeof x[k] isnt 'function'
      "\"#{k}\": #{to_json v}").join(',\n') + "}"
  else if typeof x is 'string'
    return "\"#{x}\""
  else if typeof x is 'function'
    return ''
  else
    return x.toString()


jQuery ($) ->
  drop_zone = $("#file-drop-zone")
  first = true
  $("#file-drop-zone").filedrop
    fallback_id: 'upload_button'          # an identifier of a standard file input element
    url: '/pictures/'                     # upload handler, handles each file separately, can also be a function returning a url
    paramname: 'picture[file][]'          # POST parameter name used on serverside to reference file
    withCredentials: true                 # make a cross-origin request with cookies
    data:
      #utf8: '✓'
      authenticity_token: -> $('form input[name=authenticity_token]').val()
    dragOver: -> $(this).addClass('drag-over')
    dragLeave: -> $(this).removeClass('drag-over')

    #headers:
    #  someheader: 'somevalue'
    error: (err, file) ->
      err_fn =
        BrowserNotSupported: => $(this).removeClass('dragmethod')
        TooManyFiles: ->  alert "Vous pouvez deposer au maximum #{MAX_FILES} d'un coup"
        FileTooLarge: ->  alert "Un des fichiers est trop volumineux. Il ne doit pas excèder #{MAX_FILE_SIZE}mo"
        FileTypeNotAllowed: ->  alert "Seul les fichiers jpeg sont autorisés!"

      err_fn[err]?()

    allowedfiletypes: MIMES_ALLOWED   # filetypes allowed by Content-Type.  Empty array means no restrictions
    maxfiles: MAX_FILES               # Max number of files
    maxfilesize: MAX_FILE_SIZE        # max file size in MBs
    drop: ->
      #$(this).empty().append $("""
      #  <div><span id="main-upinfo">Upload en cours...</span><span id="total-percent"></span></div>
      #  <div><span id="file-upinfo">Upload en cours...</span><span id="file-percent"></span></div>
      #  <div><span id="speed">0 ko/s</span></div>
      #  """)
      $(this).removeClass('drag-over').addClass("drag-in-progress")

      btn_all = $ """<div class="btn btn-success">Tout envoyer</div>"""
      btn_all.on 'click', -> drop_zone.find('.btn.upload').trigger('click')
      drop_zone.empty().append(btn_all)


    uploadStarted: (i, file, len) ->
      #<div class="progress progress-striped active">
      #  <div class="bar" style="width: 40%;"></div>
      #</div>

    uploadFinished: (i, file, response, time) ->
      console.log "Check for ", file
      #$.data(file).find('.media-body').text('Envoyé avec succès')
      FILES_MAP[JSON.stringify(file)].find('.media-body').text('Envoyé avec succès')
    progressUpdated: (i, file, progress) ->
      console.log "Check for ", file
      #$.data(file).find('.bar').css(width: "#{progress}%")
      FILES_MAP[JSON.stringify(file)].find('.bar').css(width: "#{progress}%")
    speedUpdated: (i, file, speed) ->
      #$("#speed").text("#{speed << 0} ko/s")
    afterAll: ->
      drop_zone.empty().text("Tout les fichiers on été envoyés.")
    beforeSend: (file, i, done) ->
      img = new Image()
      img.width = img.height = 100

      FILES_MAP[JSON.stringify(file)] = create_upload_template(file, done)
      drop_zone.append FILES_MAP[JSON.stringify(file)]
      #$.data(file, create_upload_template(file, done))

###
$('#dropzone').filedrop({
    data: {
        param1: 'value1',           // send POST variables
        param2: function(){
            return calculated_data; // calculate data at time of upload
        },
    },
    headers: {          // Send additional request headers
        'header': 'value'
    },
    error: function(err, file) {
        switch(err) {
            case 'BrowserNotSupported':
                alert('browser does not support html5 drag and drop')
                break;
            case 'TooManyFiles':
                // user uploaded more than 'maxfiles'
                break;
            case 'FileTooLarge':
                // program encountered a file whose size is greater than 'maxfilesize'
                // FileTooLarge also has access to the file which was too large
                // use file.name to reference the filename of the culprit file
                break;
            case 'FileTypeNotAllowed':
                // The file type is not in the specified list 'allowedfiletypes'
            default:
                break;
        }
    },
    allowedfiletypes: ['image/jpeg','image/png','image/gif'],   // filetypes allowed by Content-Type.  Empty array means no restrictions
    maxfiles: 25,
    maxfilesize: 20,    // max file size in MBs
    dragOver: function() {
        // user dragging files over #dropzone
    },
    dragLeave: function() {
        // user dragging files out of #dropzone
    },
    docOver: function() {
        // user dragging files anywhere inside the browser document window
    },
    docLeave: function() {
        // user dragging files out of the browser document window
    },
    drop: function() {
        // user drops file
    },
    rename: function(name) {
        // name in string format
        // must return alternate name as string
    },
    beforeEach: function(file) {
        // file is a file object
        // return false to cancel upload
    },
    beforeSend: function(file, i, done) {
        // file is a file object
        // i is the file index
        // call done() to start the upload
    },
    afterAll: function() {
        // runs after all files have been uploaded or otherwise dealt with
    }
});
###