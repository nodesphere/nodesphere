`if (typeof define !== 'function') { var define = require('amdefine')(module) }`

define (require, exports, module) ->

  NodeSphere        = require '../core/nodesphere'
  # { log, p }        = require 'lightsaber'

  # sphere
  #   title
  #   nodegroup
  #     node
  #       title
  #       content
  #       tag

  # nodes:
  #   ''    # <-- "this nodesphere"
  #   ES
  #   {
  #     title: "Core Network"
  #     content: "CN is ..."
  #   }
  # 

  # edges:
  #   '' has title ES
  #   '' has sphere d8427e548
  #   d8427e548 has node 
  # 
  # 
  # 
  # 


  ####################################################################
  class RevealDeck
  ####################################################################

    SECTION_SELECTOR = '.reveal > .slides section:not(:has(section))'  # leaf node sections only

    constructor: (options={}) ->
      # @meta = {}
      @slides = []
      
      @$sections = if options.content
        $(options.content).select SECTION_SELECTOR
      else
        $ SECTION_SELECTOR

      self = @
      @$sections.each (index) ->
        $section = $(this)
        self.slides.push(new RevealSlide $section, index)

    as_sphere: (content, callback) ->
      sphere = new NodeSphere()
      name = $('title').first().text() or $('h1').first().text()
      sphere.put_edge @sphere.key(), 'has name', name        if name
      sphere.put_edge @sphere.key(), 'has url',  options.url if options.url
      for slide in @slides
        sphere.integrate slide.as_sphere()
      callback sphere

  ####################################################################
  class RevealSlide
  ####################################################################

    constructor: (@$section, section_index) ->
      @meta = {}
      @name = @$section.data('title')
      @name or= @$section.children().first().text()
      @name = @name.trim().replace(/\s+/g, ' ') if @name?

      @meta.tags = @$section.closest("[data-tags]").data('tags') ? []

      @$section.attr('id', pretty_html_id @name) if @name and not @$section.attr 'id'
      slide_id = @$section.attr 'id'
      @meta.url = if slide_id then "#/#{slide_id}" else "#/#{section_index or ''}"

    as_sphere: ->
      sphere = new NodeSphere()
      sphere.put_edge @sphere.key(), 'has url',  options.url if options.url


    # Given the example string "  foo  bar  BAZ, yes!!!! "
    # return the id "foo-bar-BAZ-yes"
    # These IDs are designed to be both 'pretty' and widely compatible
    pretty_html_id = (name) ->
      name
        .replace(/^[^a-z]+/i, '')       # must start with a letter
        .replace(/[^a-z0-9-]/gi, '-')   # leave only letters, numbers, dashes
        .replace(/-+/gi, '-')           # only one dash at a time
        .replace(/(-$)/, '')            # no dash at end

  module.exports = RevealDeck





