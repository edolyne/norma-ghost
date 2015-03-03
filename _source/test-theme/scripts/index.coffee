###*
# Main JS file for Casper behaviours
###

### globals jQuery, document ###

(($, sr) ->
  'use strict'
  $document = $(document)

  debounce = (func, threshold, execAsap) ->
    timeout = undefined
    ->
      obj = this
      args = arguments

      delayed = ->
        if !execAsap
          func.apply obj, args
        timeout = null
        return

      if timeout
        clearTimeout timeout
      else if execAsap
        func.apply obj, args
      timeout = setTimeout(delayed, threshold or 100)
      return

  $document.ready ->
    $postContent = $('.post-content')

    updateImageWidth = ->
      $this = $(this)
      contentWidth = $postContent.outerWidth()
      imageWidth = @naturalWidth
      # Original image resolution
      if imageWidth >= contentWidth
        $this.addClass 'full-img'
      else
        $this.removeClass 'full-img'
      return

    casperFullImg = ->
      $img.each updateImageWidth
      return

    $postContent.fitVids()
    $img = $('img').on('load', updateImageWidth)
    casperFullImg()
    $(window).smartresize casperFullImg
    $('.scroll-down').arctic_scroll()
    $('.menu-button, .nav-cover, .nav-close').on 'click', (e) ->
      e.preventDefault()
      $('body').toggleClass 'nav-opened nav-closed'
      return
    return
  # smartresize

  jQuery.fn[sr] = (fn) ->
    if fn then @bind('resize', debounce(fn)) else @trigger(sr)

  # Arctic Scroll by Paul Adam Davis
  # https://github.com/PaulAdamDavis/Arctic-Scroll

  $.fn.arctic_scroll = (options) ->
    defaults =
      elem: $(this)
      speed: 500
    allOptions = $.extend(defaults, options)
    allOptions.elem.click (event) ->
      event.preventDefault()
      $this = $(this)
      $htmlBody = $('html, body')
      offset = if $this.attr('data-offset') then $this.attr('data-offset') else false
      position = if $this.attr('data-position') then $this.attr('data-position') else false
      toMove = undefined
      if offset
        toMove = parseInt(offset)
        $htmlBody.stop(true, false).animate { scrollTop: $(@hash).offset().top + toMove }, allOptions.speed
      else if position
        toMove = parseInt(position)
        $htmlBody.stop(true, false).animate { scrollTop: toMove }, allOptions.speed
      else
        $htmlBody.stop(true, false).animate { scrollTop: $(@hash).offset().top }, allOptions.speed
      return
    return

  return
) jQuery, 'smartresize'