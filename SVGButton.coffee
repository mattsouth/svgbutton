# requires d3
# goal: to create a simple library for generating svg buttons
# hide as much complexity as possible but still keep it accessible
class SVGButton
    constructor: (@parent) ->
        @rectDefaults={width: 30, height: 30, rx: 5, ry: 5, 'stroke-width': 2, stroke: 'grey', fill: 'none'}
        @textDefaults={stroke: 'grey', fill: 'none', 'font-family':'sans-serif',fill:'grey', 'font-size':14}
        @pathDefaults={width: 30, height: 30, rx: 5, ry: 5, 'stroke-width': 2, stroke: 'grey', fill: 'none'}

    # from http://coffeescriptcookbook.com/chapters/arrays/check-type-is-array
    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

    # allow opts to override provided default opts
    merge = (defaults, opts) ->
        result = {}
        for key, value of defaults
            if value == Object(value) # test if value is an object
                if opts[key]?
                    result[key] = merge(value, opts[key])
                else
                    result[key] = value
            else 
                if opts[key]? then result[key]=opts[key]
                else result[key]=value
        result

    addButtonBehaviours: (elem, hoverfill, unhoverfill, action) ->
        elem.attr("onmouseover","this.style.fill='#{hoverfill}'")
            .attr("onmouseout","this.style.fill='#{unhoverfill}'")
            .attr("onmouseup",action)
            .attr("ontouchend","this.style.fill='#{unhoverfill}'")

    addButtonBehavioursForId: (elem, id, hoverfill, unhoverfill, action) ->
        elem.attr("onmouseover","d3.select('##{id}').style('fill','#{hoverfill}')")
            .attr("onmouseout","d3.select('##{id}').style('fill','#{unhoverfill}')")
            .attr("onmouseup",action)
            .attr("ontouchend","d3.select('##{id}').style('fill','#{unhoverfill}')")

    createRect: (id, x, y, action, opts) ->
        rect = d3.select(@parent).append("rect")
            .attr("id", id).attr("x", x).attr("y", y)        
        @addButtonBehaviours rect, opts.hover, opts.rect.fill, action
        rect.attr(key, val) for key, val of opts.rect
        rect

    createText: (id, x, y, text, action, opts) ->
        elem = d3.select(@parent).append("text").text(text)
            .attr("id", id).attr("x", x).attr("y", y)        
        @addButtonBehaviours elem, opts.hover, opts.text.fill, action
        for key, val of opts.text
            elem.attr(key, val) 
        elem

    createPath: (id, x, y, path, opts) ->
        elem = d3.select(@parent).append("path")
            .attr("d",path).attr("transform","translate(#{x},#{y})").attr("id", id)
        for key, val of opts.path
            elem.attr(key, val)
        elem

    makeTextButton: (id, x, y, text, action, opts={}) ->
        mergedOpts = merge {rect: @rectDefaults, text: @textDefaults, hover: 'lightgrey'}, opts
        elem = @createText id+"text", x+2, y+2, text, action, mergedOpts
        console.log elem
        # todo work out size of text element and draw rectangle around it

    makeButton: (id, x, y, action, opts={}) ->
        mergedOpts = merge {rect: @rectDefaults, hover: 'lightgrey'}, opts
        @createRect id, x, y, action, mergedOpts

    makePathButton: (id, x, y, path, action, opts={}) ->
        mergedOpts = merge {rect: @rectDefaults, path: @pathDefaults, hover: 'lightgrey'}, opts
        @createRect id, x, y, action, mergedOpts
        elem = @createPath id+"path", x, y, path, mergedOpts
        @addButtonBehavioursForId elem, id, mergedOpts.hover, mergedOpts.path.fill, action

    ###
    var generator = new SVGButtonMaker('track-canvas')
    generator.makeStatefulButton('pause', svgbbox.width-90, svgbbox.height-45, [
        { path:'L7 24 L13 24 L13 6 L7 6 M17 6 L17 24 L23 24 L23 6 L17 6', action:'startGenerator(track)' }
        { path:'L7 24 L13 24 L13 6 L7 6 M17 6 L17 24 L23 24 L23 6 L17 6', action:'stopGenerator()' }
    ]);
    generator.makeButton('restart', svgbbox.width-45, svgbbox.height-45, 'track.clear()', {
        path: [
            { fill:'none', stroke:'grey', stroke-width:5, d:'M23 14a 8 8 0 1 1 -8 -8' },
            { fill:'grey', d:'M15 2L21 7L15 12Z' }
        ]
    });
    ###

root = exports ? window
root.SVGButton = SVGButton
