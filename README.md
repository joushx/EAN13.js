[![Build Status](https://travis-ci.org/joushx/EAN13.js.png?branch=master)](https://travis-ci.org/joushx/EAN13.js) <a href="https://flattr.com/submit/auto?user_id=joushx&url=https%3A%2F%2Fgithub.com%2Fjoushx%2FEAN13.js" target="_blank"><img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0"></a>

#EAN13
EAN13.js is a lightweight and fast JavaScript library for the generation of EAN13 barcodes. It's plain JavaScript and is also compatible with Node.js.

<img src="https://raw.github.com/joushx/EAN13.js/master/barcode.png"/>

This is a non-jQuery fork of my [jQuery.EAN13](https://github.com/joushx/jQuery.EAN13) jQuery plugin.

##Usage##

###Include Plugin###
Insert the library by placing the following code in the `head` section of your page:

```html
<script type="text/javascript" src="ean13.min.js"></script>
```

###Insert Canvas###
At the place where you want to insert the barcode insert a canvas element:

```html
<canvas id="ean" width="200" height="100">
	Your browser does not support canvas-elements.
</canvas>
```

You may change the size of the element. The barcode will be generated to match it.

###Print barcode###
For printing the code just create a new instance and call the `draw()` method:

```javascript
// create instance
var ean = new EAN13();

// properties
var element = document.getElementById("ean");
var number = "9002236311036"
var options = {};

// draw code
ean.draw(element, number, options);

```

##Options##

###Without number###
For only printing the barcode use the code below:

```javascript
var options = {
	number: false	
};
```

###Prefix###
Set the `prefix` option to false to not print the country prefix:

```javascript
var options = {
	prefix: false	
};
```

###Color###
Set the `color` option to a color to print the barcode with it.

####Hex-value####

```javascript
var options = {
	color: "#f00"
};
```

####RGB-value####

```javascript
var options = {
	color: "rgb(255,0,0)"
};
```

####RGBA-value####

```javascript
var options = {
	color: "rgb(255,0,0,0.2)"
};
```

##Callbacks##

###onValid###
When the code is valid, the `onValid` callback gets executed.

```javascript
var options = {
	onValid: function(){
		// do magic here
	}
};
```

###onInvalid###
When the code is invalid, the `onInvalid` callback gets executed.

```javascript
var options = {
	onInvalid: function(){
		// do some other magic
	}
};
```

###onSuccess###
When the barcode generation and draw process has succeeded `onSuccess` gets called.

```javascript
var options = {
	onSuccess: function(){
		// do whatever here
	}
};
```

###onError###
When the plugin (canvas-element) is not supported by the browser `onError` gets called.

```javascript
var options = {
	onError: function(){
		// do black magic
	}
};
```
