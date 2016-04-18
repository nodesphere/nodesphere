{d} = require 'lightsaber'
{defaults} = _ = require 'lodash'
promisify = require 'native-promisify-if-present'

Sphere = require '../core/sphere'

class GoogleDrive

  @create: promisify (args, callback) ->
    if not gapi?
      callback "Google API (global 'gapi' object) not found.  See: https://developers.google.com/drive/v3/web/quickstart/js"

    defaults args,
      scope: 'https://www.googleapis.com/auth/drive'
      immediate: true

    gapi.auth.authorize args, (authResult) => @handleAuthResult(authResult, args, callback)

  @handleAuthResult: (authResult, args, callback) ->
    if authResult and not authResult.error
      callback null, new GoogleDrive # {api: gapi}
    else
      _.assign args, immediate: false
      gapi.auth.authorize args, (authResult) => @handleAuthResult(authResult, args, callback)

  fetch: promisify ({rootNodeId}, callback)->
    filter = "'#{rootNodeId}' in parents" # only finds files *directly* in this folder (not in subfolders)
    @getFiles(filter).then (files) =>
      sphere = @toSphere rootNodeId, files
      callback null, sphere

  toSphere: (rootNodeId, files) =>
    sphere = new Sphere
    root = sphere.addNode id: rootNodeId
    for file in files
      sphere.addEdge
        start: root
        end: sphere.addNode(file)
    sphere

  getFiles: promisify (filter, callback) ->
    gapi.client.load 'drive', 'v3', ->
      retrievePageOfFiles = (request, result) ->
        request.execute((resp) ->
          result = result.concat resp.items
          nextPageToken = resp.nextPageToken
          if nextPageToken
            request = gapi.client.drive.files.list
              q: filter
              pageToken: nextPageToken
            retrievePageOfFiles request, result
          else
            callback null, result
        )
      initialRequest = gapi.client.drive.files.list 'q': filter

      retrievePageOfFiles initialRequest, []

  # ####################################################################
  # # Filename utilities
  # ####################################################################
  #
  # file_name_key = (file_name) ->
  #   similarity_key strip_file_extension file_name
  #
  # # Returns a key for comparison of similar strings
  # #
  # # Examples:
  # # 'tourVideo022'     -> 'tourvideo022'
  # # 'Tour Video 022'   -> 'tourvideo022'
  # # 'Tour_Video_(022)' -> 'tourvideo022'
  # similarity_key = (string) ->
  #   alphanum = string.replace /[^a-z0-9]/gi, ''
  #   alphanum.toLowerCase()
  #
  # # Strips file extensions with one or more letters.
  # # Leaves number-only extensions alone.
  # #
  # # Examples:
  # # 'x.mp3'     -> 'x'
  # # 'x.003.mp3' -> 'x.003'
  # # 'x.003'     -> 'x.003'
  # strip_file_extension = (file_name) ->
  #   file_name.replace /\.[a-z0-9]*[a-z][a-z0-9]*$/i, ''
  #
  #
  # # @child_folders: ->
  # #   gapi.client.load('drive', 'v2', ->
  # #     request = gapi.client.drive.children.list {
  # #       'folderId' : @config('core-gdrive')
  # #     }
  # #
  # #     request.execute( (resp) ->
  # #       console.log resp.items
  # #     )
  # #   )

  # @build_reveal_deck: (files) ->
  #   $reveal_deck = $ '.reveal > .slides'
  #   # $reveal_deck.children('section').remove()
  #
  #   audio_files = {}
  #   for audio_file in files when audio_file.mimeType.startsWith 'audio/'
  #     audio_files[file_name_key audio_file.title] = audio_file
  #
  #   # audio_files =
  #   #   tourvideocopy021: <gdoc tourVideocopy.021.mp3>
  #   #   tourvideocopy022: <gdoc tourVideocopy.022.mp3>
  #
  #   files.sort( (a, b) ->
  #     if      a.title.toLowerCase() < b.title.toLowerCase() then -1
  #     else if a.title.toLowerCase() > b.title.toLowerCase() then 1
  #     else 0
  #   )
  #
  #   for file in files
  #     do (file) ->
  #       if file.mimeType.startsWith 'image/'
  #         $reveal_deck.append("""
  #           <section>
  #             <img src="#{file.webContentLink}" />
  #             #{GoogleDrive.add_audio file.title, audio_files}
  #           </section>
  #         """)
  #       else if file.mimeType.startsWith 'video/'
  #         $reveal_deck.append("""
  #           <section>
  #             <video data-autoplay src="#{file.webContentLink}" />
  #           </section>
  #         """)
  #       else if file.mimeType is 'application/vnd.google-apps.document'
  #         $reveal_deck.append("""
  #           <section data-gdoc-id="#{file.id}">
  #           </section>
  #         """)
  #         html_url = file['exportLinks']['text/html']
  #         # cors_url = html_url.replace /// ^https?:// ///, 'http://cors.io/'
  #         $.get(html_url)
  #           .done( (html) -> CoreNetwork.Adaptors.GoogleDrive.add_gdoc_html(file.id, html))
  #           .fail( (data) -> console.log "Error: " + data)
  #
  #   CoreNetwork.Adaptors.RevealDeck.load()
  #
  # @add_gdoc_html: (id, html) ->
  #   elements = $.parseHTML html
  #   section = $("section[data-gdoc-id='#{id}']").first()
  #   section.append '<section>'
  #   subsection = section.children("section").last()
  #   for element in elements
  #     if element.nodeName.toLowerCase() is 'hr'
  #       section.append '<section>'
  #       subsection = section.children("section").last()
  #     else if element.nodeName.toLowerCase() not in ['title', 'meta', 'style']
  #       subsection.append element
  #
  # @add_audio: (main_slide_media_name, audio_files) ->
  #   audio_file = audio_files[file_name_key main_slide_media_name]
  #   if audio_file then """<audio data-autoplay src="#{audio_file.webContentLink}" />""" else ''

module.exports = GoogleDrive
