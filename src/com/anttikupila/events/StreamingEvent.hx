package com.anttikupila.events;

import flash.events.Event;

/**
 * @author Antti Kupila
 */
class StreamingEvent extends Event {
	
	public static var BUFFER_EMPTY : String = "bufferEmpty"; 
	public static var BUFFER_FULL : String = "bufferFull"; 
	
	public function new (type : String, bubbles : Bool = false, cancelable : Bool = false) {
		super( type, bubbles, cancelable );
	}
}
