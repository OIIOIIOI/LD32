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

import com.anttikupila.media.SoundFX;
import com.anttikupila.media.filters.IFilter;
import flash.errors.IllegalOperationError;
import openfl.Vector;

/**
 * @author Antti Kupila
 */
class DelayFilter implements IFilter {
	
	//---------------------------------------------------------------------
	//
	//  Variables
	//
	//---------------------------------------------------------------------
	
	private var _feedback : Float;
	private var _useMilliseconds : Bool;
	private var _length : Int;
	private var _mix : Float;
	
	private var invMix : Float;
	
	private var readPointer : Int = 0;
	private var writePointer : Int = 0;
	private var delayValue : Float;
	
	private var buffer : Vector<Float>;
	
	private var channelCopy : DelayFilter;
	
	public var feedback(get, set):Float;
	public var length(get, set):Int;
	public var mix(get, set):Float;
	public var useMilliseconds(get, set):Bool;
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	public function new( f : Float = 0.75, l : Int = 17640, m : Float = 0.7, u : Bool = false ) {
		_feedback = f;
		_useMilliseconds = u;
		length = l;
		_mix = m;
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Public methods
	//
	//---------------------------------------------------------------------
	
	public function process(input : Float) : Float {
		readPointer = writePointer - _length + 1;
		if ( readPointer < 0 ) readPointer += _length;
		
		delayValue = buffer[ readPointer ];
		buffer[ writePointer ] = input * ( 1 - _feedback ) + delayValue * _feedback;
		
		if ( ++writePointer == _length ) writePointer = 0;
		
		return input * ( 1 - _mix ) + delayValue * _mix;
	}
	
	public function duplicate() : IFilter {
		var l : Int = _length;
		if ( _useMilliseconds ) l = Std.int(l / SoundFX.SAMPLE_RATE * 0.001);
		channelCopy = new DelayFilter( _feedback, l, _mix, _useMilliseconds );
		return channelCopy;
	}
	
	function get_feedback() : Float {
		return _feedback;
	}
	
	function set_feedback(f : Float) : Float {
		_feedback = f;
		if ( channelCopy != null ) channelCopy.feedback = _feedback;
		return _feedback;
	}
	
	function set_length(length : Int) : Int {
		if ( channelCopy != null ) channelCopy.length = length;
		if ( _useMilliseconds ) {
			length = Std.int( length * SoundFX.SAMPLE_RATE * 0.001 );
		}
		var newBuffer : Vector<Float> = new Vector<Float>( length, true );
		if ( buffer != null ) newBuffer.concat( buffer );
		buffer = newBuffer;
		writePointer = 0;
		_length = length;
		return _length;
	}
	
	function get_length() : Int {
		return _length;
	}
	
	function get_mix() : Float {
		return _mix;
	}
	
	function set_mix(m : Float) : Float {
		_mix = m;
		if ( channelCopy != null ) channelCopy.mix = _mix;
		return _mix;
	}
	
	public function get_useMilliseconds() : Bool {
		return _useMilliseconds;
	}
	
	public function set_useMilliseconds(u : Bool) : Bool {
		_useMilliseconds = u;
		if ( channelCopy != null ) channelCopy.useMilliseconds = _useMilliseconds;
		return _useMilliseconds;
	}
}