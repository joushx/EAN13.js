[![Build Status](https://travis-ci.org/joushx/EAN13.jspng?branch=master)](https://travis-ci.org/joushx/EAN13.js)

#EAN13
EAN13 is a lightweight (~3kb) JavaScript library for in-place generation of EAN-13 barcodes.

<img src="https://raw.github.com/joushx/EAN13.js/master/barcode.png"/>

This is a non-jQuery fork of my [jQuery.EAN13](https://github.com/joushx/jQuery.EAN13) jQuery plugin.

##Usage##

###Include Plugin###
Insert the following code into the `head` section of you page:

```html
<script type="text/javascript" src="ean13.min.js"></script>
```

###Insert Canvas###
At the place where you want to insert the barcode insert this code:

```html
<canvas id="ean" width="200" height="100">
	Your browser does not support canvas-elements.
</canvas>
```

You may change the dimensions of the element. The barcode will automatically be resized.

###Print barcode###
For printing the code of the provided number with the number under it, just use the following code:

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

##Author##
Johannes Mittendorfer (http://johannes-mittendorfer.com)
