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

/*
 * Ported from http://www.musicdsp.org/archive.php?classid=3#38
 *
 * @author Antti Kupila
 */
package com.anttikupila.media.filters;

import com.anttikupila.media.SoundFX;	

class HighpassFilter implements IFilter {

	//---------------------------------------------------------------------
	//
	//  Variables
	//
	//---------------------------------------------------------------------
	
	var f : Float = 0;
	var r : Float = 1.4142135623730951;
	var fs : Float = SoundFX.SAMPLE_RATE;

	var a1 : Float;
	var a2 : Float;
	var a3 : Float;
	var b1 : Float;
	var b2 : Float;
	var c : Float;

	var in1 : Float;
	var in2 : Float;
	var out1 : Float;
	var out2 : Float;
	var output : Float;

	private var channelCopy : HighpassFilter;

	public var cutoffFrequency(get, set):Float;
	public var resonance(get, set):Float;
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	public function new( cutoffFrequency : Float = 8000, resonance : Float = 1.4142135623730951 ) {
		f = cutoffFrequency;
		r = resonance;
		
		in1 = in2 = out1 = out2 = 0;
		
		calculateParameters( );
	}

	
	//---------------------------------------------------------------------
	//
	//  Protected methods
	//
	//---------------------------------------------------------------------
	
	function calculateParameters( ) : Void {
		c = Math.tan( Math.PI * f / fs );
		a1 = 1.0 / ( 1.0 + r * c + c * c);
		a2 = -2 * a1;
		a3 = a1;
		b1 = 2.0 * ( c * c - 1.0) * a1;
		b2 = ( 1.0 - r * c + c * c) * a1;
	}
	
	//---------------------------------------------------------------------
	//
	//  Public methods
	//
	//---------------------------------------------------------------------
	
	public function process( input : Float ) : Float {
		output = a1 * input + a2 * in1 + a3 * in2 - b1 * out1 - b2 * out2;
		
		in2 = in1;
		in1 = input;
		out2 = out1;
		out1 = output;
		
		return output;
	}

	public function duplicate() : IFilter {
		channelCopy = new HighpassFilter( cutoffFrequency, resonance );
		return channelCopy;
	}

	public function set_cutoffFrequency( frequency : Float ) : Float {
		f = frequency;
		if ( f >= SoundFX.SAMPLE_RATE * 0.5 ) f = SoundFX.SAMPLE_RATE * 0.5 - 1; 
		if ( channelCopy != null ) channelCopy.cutoffFrequency = f;
		calculateParameters( );
		return f;
	}

	public function get_cutoffFrequency( ) : Float {
		return f;
	}

	public function set_resonance( resonance : Float ) : Float {
		r = resonance;
		if ( channelCopy != null ) channelCopy.resonance = r;
		calculateParameters( );
		return r;
	}

	public function get_resonance( ) : Float {
		return r;
	}
}
