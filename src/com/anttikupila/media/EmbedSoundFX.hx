package com.anttikupila.media;

import com.anttikupila.events.StreamingEvent;
import com.anttikupila.media.filters.IFilter;
import openfl.Assets;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.SampleDataEvent;
import openfl.events.TimerEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

class EmbedSoundFX extends SoundFX {
	
	var embedSound:Sound;
	
	public function new (path:String) {
		embedSound = Assets.getSound(path);
		if (embedSound == null)	throw new Error("invalid path");
		super();
	}
	
	override private function sampleDataHandler( event : SampleDataEvent ) : Void {
		samples.position = 0;
		var availableSampleCount : Int = Std.int(embedSound.extract( samples, _outputBuffer, sampleIndex ));
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
					left = samples.readFloat( );
					right = samples.readFloat( );
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
	
	override function bufferTimerHandler( event : TimerEvent ) : Void {
		if ( embedSound.length * 0.001 - sampleIndex / SoundFX.SAMPLE_RATE >= _networkBuffer ) { // convert length to milliseconds
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
	
	override public function play( startTime : Float = 0, loops : Int = 0, sndTransform : SoundTransform = null ) : SoundChannel {
		this.loops = loops;
		this.soundTransform = sndTransform;
		position = startTime;
		startBuffering( true );
		return null;
	}
	
}
