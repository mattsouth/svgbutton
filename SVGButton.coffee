# requires d3
# goal: to create a simple library for generating svg buttons
# hide as much complexity as possible but still keep it accessible
class SVGButton
    constructor: (@parent) ->

    updateFill: (id, fill) ->
        d3.select('#'+id).style("fill", fill)

    addButtonBehaviours: (elem, hoverfill, unhoverfill, action) ->
        elem.attr("onmouseover","this.style.fill='#{hoverfill}'")
            .attr("onmouseout","this.style.fill='#{unhoverfill}'")
            .attr("onmouseup",action)
            .attr("ontouchend","this.style.fill='#{unhoverfill}'")

    addButtonBehavioursForId: (elem, id, hoverfill, unhoverfill, action) ->
        elem.attr("onmouseover","updateFill(#{id},'#{hoverfill}')")
            .attr("onmouseout","updateFill(#{id},'#{unhoverfill}')")
            .attr("onmouseup",action)
            .attr("ontouchend","updateFill(#{id},'#{unhoverfill}')")

    createRect: (id, x, y, action, opt) ->
        rect = d3.select(@parent).append("rect")
            .attr("id", id).attr("x", x).attr("y", y)
        @addButtonBehaviours rect, opt.hover, opt.rect.fill, action
        rect.attr(key, val) for key, val of opt.rect

    makeTextButton: (id, x, y, text, action) ->
        rect = @createRect id, x, y, action, opt
        elem = d3.select(@parent).append("text")
            .attr("id", id+"text").attr("x", x+2).attr("y", y+2)
        @addButtonBehavioursForId(elem, id, 'lightgrey', 'none', action)

    makeButton: (id, x, y, action, options={rect: {width: 30, height: 30, rx: 5, ry: 5, 'stroke-width': 2, stroke: 'grey', fill: 'none'}, hover: 'lightgrey'}) ->
        @createRect id, x, y, action, options

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
