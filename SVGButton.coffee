# requires d3
# goal: to create a simple library for generating svg buttons
# hide as much complexity as possible by providing sensible defaults 
# but allow the svg elements to be fully manipulated
root = exports ? window

class SVGButton
    constructor: (@parent) ->
        @rectDefaults={rx: 5, ry: 5, 'stroke-width': 2, stroke: 'grey', fill: 'none'}
        @textDefaults={stroke: 'grey', fill: 'none', 'font-family':'sans-serif',fill:'grey', 'font-size':14}
        @pathDefaults={'stroke-width': 2, stroke: 'grey', fill: 'none', d:''}

    # from http://coffeescriptcookbook.com/chapters/arrays/check-type-is-array
    typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

    # allow opts to override provided default opts
    merge = (defaults, opts) ->
        result = {}
        for key, value of defaults
            if typeIsArray value
                result[key]=[]
                for item, idx in value
                    result[key].push merge(value[idx], opts[key][idx])
            else if value == Object(value) # test if value is an object
                if opts[key]?
                    result[key] = merge(value, opts[key])
                else
                    result[key] = value
            else
                if opts[key]? then result[key]=opts[key]
                else result[key]=value
        result[key]=opts[key] for key in Object.keys(opts) when key not in Object.keys(defaults)        
        result

    addButtonBehaviours = (elem, hoverfill, unhoverfill, action) ->
        elem.attr("onmouseover","this.style.fill='#{hoverfill}'")
            .attr("onmouseout","this.style.fill='#{unhoverfill}'")
            .attr("onmouseup",action)
            .attr("ontouchend","this.style.fill='#{unhoverfill}'")

    addButtonBehavioursForId = (elem, id, hoverfill, unhoverfill, action) ->
        elem.attr("onmouseover","d3.select('##{id}').style('fill','#{hoverfill}')")
            .attr("onmouseout","d3.select('##{id}').style('fill','#{unhoverfill}')")
            .attr("onmouseup",action)
            .attr("ontouchend","d3.select('##{id}').style('fill','#{unhoverfill}')")

    createRect: (id, x, y, action, opts) ->
        rect = d3.select(@parent).append("rect")
            .attr("id", id).attr("x", x).attr("y", y) 
            .attr("width", opts.width).attr("height", opts.height)       
        addButtonBehaviours rect, opts.hover, opts.rect.fill, action
        rect.attr(key, val) for key, val of opts.rect
        rect

    createText: (id, x, y, text, action, opts) ->
        elem = d3.select(@parent).append("text").text(text)
            .attr("id", id).attr("x", x).attr("y", y)        
        addButtonBehaviours elem, opts.hover, opts.text.fill, action
        for key, val of opts.text
            elem.attr(key, val) 
        elem

    createPath: (id, x, y, opts) ->
        elem = d3.select(@parent).append("path")
            .attr("transform","translate(#{x},#{y})").attr("id", id)
        for key, val of opts
            elem.attr(key, val)
        elem

    makeTextButton: (id, x, y, text, action, opts={}) ->
        mergedOpts = merge {rect: @rectDefaults, text: @textDefaults, hover: 'lightgrey'}, opts
        elem = @createText id+"text", x+2, y+2, text, action, mergedOpts
        console.log elem
        # todo: work out size of text element and draw rectangle around it

    makeButton: (id, x, y, action, opts={}) ->
        console.log 'makebutton', id, x, y, action, opts
        defaults = {width:30, height:30, hover: 'lightgrey', rect: @rectDefaults, text: @textDetaults}
        if opts.path?
            if typeIsArray opts.path
                defaults.path = []
                for instance in opts.path
                    defaults.path.push @pathDefaults
            else
                defaults.path = @pathDefaults
        mergedOpts = merge defaults, opts
        console.log 'mergedOpts',opts
        @createRect id, x, y, action, mergedOpts
        if mergedOpts.path?
            if typeIsArray mergedOpts.path
                for instance, idx in mergedOpts.path
                    elem = @createPath "#{id}path#{idx}", x, y, mergedOpts.path[idx] 
                    addButtonBehavioursForId elem, id, mergedOpts.hover, mergedOpts.path.fill, action
            else
                elem = @createPath "#{id}path", x, y, mergedOpts.path
                addButtonBehavioursForId elem, id, mergedOpts.hover, mergedOpts.path.fill, action
        # todo: add text

    # opts is an array of meta - one array element per state - including an extra action attribute
    # first element of array assumed default state
    makeStatefulButton: (id, x, y, opts={}) ->

        if typeIsArray opts
            root[id]=0 # set current state variable
            for state, idx in opts
                if idx!=0 then state.class='invisible'
                state.action = "updateState('#{id}', #{opts.length}); " + state.action
                @makeButton "#{id}#{idx}", x, y, state.action, state
        else
            console.log "expecting an array of opts containing opts for each state"

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


updateState = (id, numstates) ->
    d3.select("##{id}#{root[id]}").attr('class', 'invisible')
    if root[id]==numstates then root[id]=0 else root[id]++
    d3.select("##{id}#{root[id]}").attr('class', '')

root.updateState = updateState
root.SVGButton = SVGButton
