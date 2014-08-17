define (require, exports, module) ->

  # NodeSphere        = require 'core/node_sphere'
  # { log, p }        = require 'lightsaber/log'

  ####################################################################
  class RevealDeck
  ####################################################################

    @as_sphere: (callback) ->
      @load_slides()
      sphere = new NodeSphere()
      sphere.describe @meta
      for slide in @slides
        sphere.add slide.name, slide.meta
      callback sphere

    @load_slides: ->
      self = this
      self.slides = []
      sections = $ '.reveal > .slides section:not(:has(section))'  # leaf node sections only
      sections.each (index) ->
        if index==0
          home_slide = new RevealSlide sections.first(), index
          self.meta =
            name: home_slide.name
            url: home_slide.meta.url
        else
          self.slides.push(new RevealSlide $(this), index)

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

    add_meta: (key, value) ->
      throw "Expected key (#{key}) to be present" unless key?
      throw "Expected value (#{value}) to be an array" unless type(value) is 'array'
      @meta[key] ?= []
      @meta[key].push value...

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