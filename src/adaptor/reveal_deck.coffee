# lightsaber  = require 'lightsaber'
# Nodesphere = require '../core/nodesphere'

# {
#   doc
#   log
#   p
#   pretty
#   type
#   sha384
# } = lightsaber

# # sphere
# #   title
# #   nodegroup
# #     node
# #       title
# #       content
# #       tag

# # nodes:
# #   ''    # <-- "this nodesphere"
# #   ES
# #   {
# #     title: "Core Network"
# #     content: "CN is ..."
# #   }
# # 

# # edges:
# #   '' has title ES
# #   '' has sphere d8427e548
# #   d8427e548 has node 
# # 
# # 
# # 
# # 

# ####################################################################
# class RevealDeck
# ####################################################################

#   SECTION_SELECTOR = '.reveal > .slides section:not(:has(section))'  # leaf node sections only

#   constructor: (@params={}) ->
#     # @meta = {}
#     @slides = []

#     throw "params.content not found" unless @params.content
#     content = @params.content
#     @content_id = sha384 content
#     @$content = doc content
#     @$sections = @$content SECTION_SELECTOR

#     self = @
#     @$sections.each (index) ->
#       $section = $(this)
#       self.slides.push(new RevealSlide $section, index)

#   as_sphere: ->
#     sphere = new Nodesphere()
#     name = @$content('title').first().text() or @$content('h1').first().text()
#     sphere.put_edge @content_id, 'has name', name if name
#     for own key, value of @params
#       sphere.put_edge @content_id, "has #{key}", value
#     for slide in @slides
#       sphere.integrate slide.as_sphere()
#     sphere

# ####################################################################
# class RevealSlide
# ####################################################################

#   constructor: (@$section, section_index) ->
#     @name = @$section.data('title')
#     @name or= @$section.children().first().text()
#     @name = @name.trim().replace(/\s+/g, ' ') if @name?
#     @content_id = sha384 @$section.html()

#     @meta = {}
#     @meta.tags = @$section.closest("[data-tags]").data('tags') ? []
#     @$section.attr('id', _pretty_html_id @name) if @name and not @$section.attr 'id'
#     slide_id = @$section.attr 'id'
#     @meta.url = if slide_id then "#/#{slide_id}" else "#/#{section_index or ''}"
#     @meta.content = @$section.html()

#   as_sphere: ->
#     sphere = new Nodesphere()
#     sphere.put_edge @content_id, 'has name', @name if @name
#     for own key, value of @meta
#       sphere.put_edge @content_id, "has #{key}", value
#     sphere


#   # Given the example string "  foo  bar  BAZ, yes!!!! "
#   # return the id "foo-bar-BAZ-yes"
#   # These IDs are designed to be both 'pretty' and widely compatible
#   _pretty_html_id = (name) ->
#     name
#       .replace(/^[^a-z]+/i, '')       # must start with a letter
#       .replace(/[^a-z0-9-]/gi, '-')   # leave only letters, numbers, dashes
#       .replace(/-+/gi, '-')           # only one dash at a time
#       .replace(/(-$)/, '')            # no dash at end

# module.exports = RevealDeck
