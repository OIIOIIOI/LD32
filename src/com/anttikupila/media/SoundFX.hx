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

http://www.anttikupila.com/flash/soundfx-out-of-the-box-audio-filters-with-actionscript-3/
*/

package com.anttikupila.media;

import com.anttikupila.events.StreamingEvent;
import com.anttikupila.media.filters.IFilter;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.utils.Timer;	

/**
 * <p>Provides an easy way to transform audio output in real time with a syntax familiar from display object filters</p>
 * 
 * <listing version="3.0">
 * var sound : SoundFX = new SoundFX( new URLRequest( "music.mp3" ) );
 * sound.filters = [ new CutoffFilter( 12000 ) ];
 * sound.play( );
 * </listing>
 * 
 * <p>SoundFX also provides greated control over buffering and precise seeking</p>
 * 
 * <listing version="3.0">
 * var sound : SoundFX = new SoundFX( null, null, 3 ); // 3 seconds need to be loaded before playback starts
 * sound.load( new URLRequest( "music.mp3" ) );
 * sound.play( );
 * // a bit later..
 * sound.position = 3.12312;
 * </listing>
 */
class SoundFX extends Sound {

	//---------------------------------------------------------------------
	//
	//  Constants
	//
	//---------------------------------------------------------------------

	public static var SAMPLE_RATE : Int = 44100;
	public static var DEFAULT_OUTPUT_BUFFER : Int = 2048;
	public static var DEFAULT_NETWORK_BUFFER : Float = 1; // seconds

	
	//---------------------------------------------------------------------
	//
	//  Variables
	//
	//---------------------------------------------------------------------

	private var output : Sound;
	private var bufferTimer : Timer;
	public var soundChannel : SoundChannel;

	private var stream : URLRequest;
	private var samples : ByteArray;
	
	private var loops : Int;
	public var soundTransform : SoundTransform;
	public var buffering(get, null) : Bool;
	private var sampleIndex : Int = 0;

	private var _networkBuffer : Float;
	private var _outputBuffer : Int;
	private var _filtersLeft : Array<IFilter>;
	private var _filtersRight : Array<IFilter>;
	
	private var _paused : Bool = false;
	
	public var filters (get, set) : Array<IFilter>;
	public var networkBuffer(get, set) : Float;
	public var outputBuffer(get, set) : Float;
	public var position(get, set) : Float;
	public var paused(get, set) : Bool;
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------

	/**
	 * @param stream File to load
	 * @param context Context
	 * @param networkBuffer Network buffer in seconds. Similar to the buffer in NetStream
	 * @param outputBufferLength Output buffer in samples. If the output is choppy even if the network is smooth try increasing the output buffer
	 */
	public function new ( stream : URLRequest = null, context : SoundLoaderContext = null, networkBufferSeconds : Float = 1, outputBufferLength : Int = 2048 ) {
		super( null, null );
		
		_filtersLeft = new Array();
		_filtersRight = new Array();
		
		samples = new ByteArray( );
		output = new Sound( );
		output.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleDataHandler );
		
		outputBuffer = outputBufferLength;
		networkBuffer = networkBufferSeconds;
		
		bufferTimer = new Timer( 30 );
		bufferTimer.addEventListener( TimerEvent.TIMER, bufferTimerHandler );
		
		if ( stream != null ) load( stream, context );
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Protected methods
	//
	//---------------------------------------------------------------------
	
	/**
	 * @internal Starts a timer that checks when enough of the track has loaded for playback
	 */
	private function startBuffering( force : Bool = false ) : Void {
		if ( super.isBuffering || Std.int(bytesLoaded) < Std.int(bytesTotal) || force ) {
			if ( !buffering ) { 
				buffering = true;
				bufferTimer.start( );
				dispatchEvent( new StreamingEvent( StreamingEvent.BUFFER_EMPTY ) );
			}
			bufferTimerHandler( null );
		}
	}

	
	//---------------------------------------------------------------------
	//
	//  Events
	//
	//---------------------------------------------------------------------

	/**
	 * @internal Main audio processor
	 */
	private function sampleDataHandler( event : SampleDataEvent ) : Void {
		samples.position = 0;
		var availableSampleCount : Int = Std.int(extract( samples, _outputBuffer, sampleIndex ));
		samples.position = 0;
		
		if ( availableSampleCount < _outputBuffer ) {
			if ( !buffering ) startBuffering( );
		}
		
		if ( buffering || availableSampleCount > 0 ) {
			var left : Float,
				right : Float,
				filter : IFilter;
			for (i in 0...Std.int(Math.min( _outputBuffer, availableSampleCount ))) {
				if ( buffering || _paused ) {
					// Input silence into filters while paused or buffering
					left = right = 0;
				} else {
					left = samples.readFloat();
					right = samples.readFloat();
				}
				
				for ( filter in _filtersLeft ) {
					left = filter.process( left );
				}
				for ( filter in _filtersRight ) {
					right = filter.process( right );
				}
				
				event.data.writeFloat( left );
				event.data.writeFloat( right );
			}
			
			if ( !buffering && !_paused ) sampleIndex += _outputBuffer;
		}
	}
	
	/**
	 * @internal Checks if the network buffer has been filled and starts playback if enough data is available
	 */
	function bufferTimerHandler( event : TimerEvent ) : Void {
		if ( length * 0.001 - sampleIndex / SAMPLE_RATE >= _networkBuffer ) { // convert length to milliseconds
			bufferTimer.stop( );
			buffering = false;
			if ( soundChannel != null ) {
				soundChannel.removeEventListener( Event.SOUND_COMPLETE, soundCompleteHandler );
				soundChannel.stop( );
			}
			soundChannel = output.play( 0, loops, soundTransform );
			soundChannel.addEventListener( Event.SOUND_COMPLETE, soundCompleteHandler );
			dispatchEvent( new StreamingEvent( StreamingEvent.BUFFER_FULL ) );
		}
	}
	
	/**
	 * @internal Easy bridge to check for sound completion
	 */
	function soundCompleteHandler( event : Event ) : Void {
		if ( Std.int(bytesLoaded) >= Std.int(bytesTotal) ) dispatchEvent( event );
	}

	
	//---------------------------------------------------------------------
	//
	//  Public methods
	//
	//---------------------------------------------------------------------

	/**
	 * <p>Starts playing the sound</p>
	 * <p>Note: unlike <code>flash.media.Sound</code> play() does <strong>not</strong> return a SoundChannel</p>
	 * 
	 * @param startTime Start time in seconds
	 * @param loops Number of loops
	 * @param sndTransform Sound transform
	 * 
	 * @return null
	 */
	override public function play( startTime : Float = 0, loops : Int = 0, sndTransform : SoundTransform = null ) : SoundChannel {
		if ( stream == null ) throw new IllegalOperationError( "Sound cannot be played without a valid stream" );
		this.loops = loops;
		this.soundTransform = sndTransform;
		position = startTime;
		startBuffering( true );
		return null;
	}
	
	/**
	 * @see flash.media.Sound#load()
	 */
	override public function load( stream : URLRequest, context : SoundLoaderContext = null ) : Void {
		this.stream = stream;
		super.load( stream, context );
	}

	/**
	 * Indexed array of filters to process the audio through before output
	 */
	function get_filters( ) : Array<IFilter> {
		return _filtersLeft;
	}
	
	/**
	 * @private
	 */
	function set_filters( a : Array<IFilter> ) : Array<IFilter> {
		_filtersLeft = a;
		_filtersRight = [ ];
		for (f in _filtersLeft) {
			_filtersRight.push( f.duplicate( ) );
		}
		return a;
	}
	
	function get_buffering () :Bool {
		return buffering;
	}
	
	/**
	 * Amount of seconds that need to be buffered before sound will start playing
	 */
	function get_networkBuffer( ) : Float {
		return _networkBuffer;
	}
	
	/**
	 * @private
	 */
	function set_networkBuffer( nb : Float ) : Float {
		_networkBuffer = Math.max( nb, _outputBuffer / SAMPLE_RATE );
		return _networkBuffer;
	}
	
	/**
	 * Output buffer size
	 */
	function get_outputBuffer( ) : Float {
		return _outputBuffer;
	}
	
	/**
	 * @private
	 */
	function set_outputBuffer( ob : Float ) : Float {
		_outputBuffer = Std.int(Math.max( ob, 0 ));
		return _outputBuffer;
	}
	
	/**
	 * Current playhead position
	 */
	function get_position( ) : Float {
		return sampleIndex / SAMPLE_RATE;
	}
	
	/**
	 * @private
	 */
	function set_position( p : Float ) : Float {
		sampleIndex = Std.int( Math.min( length, p ) * SAMPLE_RATE );
		return p;
	}
	
	/**
	 * <p>Return an estimated length based on currently loaded bytes</p>
	 * <p>While the result isn't exactly correct it is useful for showing progress of the playing track, dividing SoundFX.position with SoundFX.getLenght()</p>
	 * 
	 * @see #position
	 * 
	 * @return An estimated length
	 */
	public function getLength( ) : Float {
		if ( bytesLoaded <= 0 ) return 0;
		return length / ( bytesLoaded / bytesTotal ) * 0.001;
	}
	
	/**
	 * Specifies if the track is paused. Unlike stopping a track pausing it will continue to process filters without advancing the playhead.
	 * 
	 * @param paused True if track should be paused
	 */
	function get_paused() : Bool {
		return _paused;
	}
	
	/**
	 * @private
	 */
	function set_paused(p : Bool) : Bool {
		_paused = p;
		return _paused;
	}
	
}