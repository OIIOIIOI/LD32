/*
The MIT License

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.anttikupila.media.filters;

import com.anttikupila.media.filters.IFilter;
import openfl.Vector;

/**
 * @author Antti Kupila
 */
class FlangeFilter implements IFilter {
	
	//---------------------------------------------------------------------
	//
	//  Variables
	//
	//---------------------------------------------------------------------
	
	private var _feedback : Float;
	private var _delay : Float;
	private var _length : Int;
	
	private var offset : Float;
	
	private var i : Int = 0;
	
	private var buffer : Vector<Float>;
	
	private var channelCopy : FlangeFilter;
	
	public var feedback(get, set):Float;
	public var delay(get, set):Float;
	public var length(get, set):Int;
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	public function new( l : Int = 17600, d : Float = 880, f : Float = 0.7 ) {
		_feedback = f;
		_delay = d;
		this.length = l;
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Public methods
	//
	//---------------------------------------------------------------------
	
	public function process(input : Float) : Float {
		offset = i - delay;
		if ( offset < 0 ) offset += _length;
		
		var index0 : Int = Std.int( offset ),
			index_1 : Int = index0 - 1,
			index1 : Int = index0 + 1,
			index2 : Int = index0 + 2;
			
		if ( index_1 < 0 ) index_1 = Std.int(_length - 1);
		if ( index1 >= _length ) index1 = 0; 
		if ( index2 >= _length ) index2 = 0; 
		
		var y_1 : Float = buffer[ index_1 ],
			y0 : Float = buffer[ index0 ],
			y1 : Float = buffer[ index1 ],
			y2 : Float = buffer[ index2 ];
			
		var x : Float = offset - index0;
			
		var c0 : Float = y0,
			c1 : Float = 0.5 * ( y1 - y_1 ),
			c2 : Float = y_1 - 2.5 * y0 + 2 * y1 - 0.5 * y2,
			c3 : Float = 0.5 * ( y2 - y_1 ) + 1.5 * ( y0 - y1 );
			
		var output : Float = ( ( c3 * x + c2 ) * x + c1 ) * x + c0;
		
		buffer[ i ] = input + output * feedback;
		
		if ( ++i == _length ) i = 0;
		
		return output;
	}
	
	
	public function duplicate() : IFilter {
		channelCopy = new FlangeFilter( _length, _delay, _feedback );
		return channelCopy;
	}
	
	function get_feedback() : Float {
		return _feedback;
	}
	
	function set_feedback(f : Float) : Float {
		_feedback = f;
		if ( channelCopy != null ) channelCopy.feedback = f;
		return _feedback;
	}
	
	function get_delay() : Float {
		return _delay;
	}
	
	function set_delay(d : Float) : Float {
		_delay = d;
		if ( channelCopy != null ) channelCopy.delay = d;
		return _delay;
	}
	
	function get_length() : Int {
		return _length;
	}
	
	function set_length(l : Int) : Int {
		_length = l;
		if ( channelCopy != null ) channelCopy.length = l;
		buffer = new Vector(_length);
		return _length;
	}
}
