# use ecma 5 strict mode
"use strict"

# create class
class EAN13
  # properties

  # default option values
  defaults:

    # settings
    number: true
    prefix: true
    color: "#000"
    
    # Offset
    offsetX:0
    offsetY:0

    # callbacks
    onValid: ->
    onInvalid: ->
    onSuccess: ->
    onError: ->
    
  # real option values
  options: {}

  # methods

  constructor: ->
  draw: (element, number, _options) ->

    # parse option values and replace by defaults
    @parseOptions(_options)

    # get binary code
    code = @getCode(number)

    # print code to canvas@par
    @print(element, code, number)

  print: (element, code, number) ->
    # layout vars
    layout =
      prefix_offset: 0.06
      font_stretch: 0.073
      border_line_height_number: 0.9
      border_line_height: 1
      line_height: 0.9
      font_size: 0.15
      font_y: 1.03
      text_offset: 4.5
      
    #Offset
    offsetX = @options.offsetX
    offsetY = @options.offsetY

    # get width of barcode element
    width = @options.width || element.width
    width = (if @options.prefix then width * 0.8 else width)

    height = @options.height || element.height
    # check if number should be printed
    if @options.number
      border_height = layout.border_line_height_number * height
    else
      border_height = layout.border_line_height * height
      
    height = layout.line_height * border_height

    # calculate width of every element
    item_width = width / 95

    # check if canvas-element is available
    if element.getContext

      # get draw context
      context = element.getContext("2d")

      #clear canvas from previous draw
      @clear(element, context)

      # set fill color
      context.fillStyle = @options.color

      # init var for offset in x-axis
      left = (if @options.prefix then element.width * layout.prefix_offset else 0)

      # get chars of code for drawing every line
      lines = code.split("")

      # add left border
      context.fillRect offsetX+left, offsetY, item_width, border_height
      left = left + item_width * 2
      context.fillRect offsetX+left, offsetY, item_width, border_height
      left = left + item_width

      # loop through left lines
      i = 0
      while i < 42

        # if char is 1: draw a line
        context.fillRect offsetX+left, offsetY, item_width, height  if lines[i] is "1"

        # alter offset
        left = left + item_width
        i++

      # add center
      left = left + item_width
      context.fillRect offsetX+left, offsetY, item_width, border_height
      left = left + item_width * 2
      context.fillRect offsetX+left, offsetY, item_width, border_height
      left = left + item_width * 2

      # loop through right lines
      i = 42
      while i < 84

        # if char is 1: draw a line
        context.fillRect offsetX+left, offsetY, item_width, height  if lines[i] is "1"

        # alter offset
        left = left + item_width
        i++

      # add right border
      context.fillRect offsetX+left, offsetY, item_width, border_height
      left = left + item_width * 2
      context.fillRect offsetX+left, offsetY, item_width, border_height

      # add number representation if settings.number == true
      if @options.number

        # set font style
        context.font = layout.font_size * height + "px monospace"

        # get prefix
        prefix = number.substr(0, 1)

        # print prefix
        context.fillText prefix, offsetX+0, offsetY+(border_height * layout.font_y)  if @options.prefix

        # init offset
        offset = item_width * layout.text_offset + ((if @options.prefix then layout.prefix_offset * element.width else 0))

        # split number
        chars = number.substr(1, 6).split("")

        # loop though left chars
        for char in chars

          # print text
          context.fillText char, offsetX+offset, offsetY+(border_height * layout.font_y)

          # alter offset
          offset += layout.font_stretch * width

        # offset for right numbers
        offset = 49 * item_width + ((if @options.prefix then layout.prefix_offset * element.width else 0)) + layout.text_offset

        # split number
        chars = number.substr(7).split("")

        # loop though right chars
        for char in chars

          # print text
          context.fillText char, offsetX+offset, offsetY+(border_height * layout.font_y)

          # alter offset
          offset += layout.font_stretch * width

      if @options.onSuccess
        @options.onSuccess.call()
    else
      #call error callback
      if @options.onError
        @options.onError.call()

  clear: (element, context) ->
    # clear canvas
    context.clearRect(@options.offsetX, @options.offsetY, @options.width || element.width, @options.height || element.height)

  parseOptions: (_options) ->
    `
    this.options=_options;
    for(var option in this.defaults)
      this.options[option] = _options[option] || this.defaults[option];
    `
    null

  getCode: (number) ->
    # check if code is valid
    if @validate(number)
      if @options.onValid
        @options.onValid.call()
    else
      if @options.onInvalid
        @options.onInvalid.call()

    # EAN 13 code tables
    x = ["0001101", "0011001", "0010011", "0111101", "0100011", "0110001", "0101111", "0111011", "0110111", "0001011"]
    y = ["0100111", "0110011", "0011011", "0100001", "0011101", "0111001", "0000101", "0010001", "0001001", "0010111"]
    z = ["1110010", "1100110", "1101100", "1000010", "1011100", "1001110", "1010000", "1000100", "1001000", "1110100"]
    
    # countries table
    countries = ["xxxxxx", "xxyxyy", "xxyyxy", "xxyyyx", "xyxxyy", "xyyxxy", "xyyyxx", "xyxyxy", "xyxyyx", "xyyxyx"]

    # init code variable for saving of lines
    code = ""

    # get country encoding
    c_encoding = countries[parseInt(number.substr(0, 1), 10)].split("")

    # remove country-prefix
    raw_number = number.substr(1)

    # get chars of input number
    parts = raw_number.split("")

    # loop through left groups
    i = 0
    while i < 6
      if c_encoding[i] is "x"
        code += x[parts[i]]
      else
        code += y[parts[i]]
      i++

    # loop through right groups
    i = 6
    while i < 12
      code += z[parts[i]]
      i++

    #return result
    return code

  validate:(number) ->
    # init result var
    result = null

    # split and reverse number
    chars = number.split("")

    # init counter
    counter = 0

    # loop through chars
    for value in chars
      # check if odd
      if _i % 2 is 0

        # count up counter
        counter += parseInt(value, 10)

      else
        
        # count up counter
        counter += 3 * parseInt(value, 10)
    
    # check if result % 10 is 0
    if (counter % 10) is 0
      result = true
    else
      result = false
    
    # return result
    result
    
if (typeof(module)!='undefined' && typeof(module.exports)!='undefined')
  module.exports=EAN13
