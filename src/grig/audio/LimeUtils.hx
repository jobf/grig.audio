package grig.audio;

#if lime

class LimeUtils
{
    public static function limeAudioBufferToInterleaved(buffer:lime.media.AudioBuffer):Array<Float> {
        var newBuffer = new Array<Float>();
        if (buffer.bitsPerSample == 8) {    
            newBuffer.resize(buffer.data.length);
			for (i in 0...buffer.data.length) {
				newBuffer[i] = buffer.data[i] / 128.0;
			}
		}
		else if (buffer.bitsPerSample == 16) {
			var input = new haxe.io.BytesInput(buffer.data.toBytes());
            newBuffer.resize(Std.int(buffer.data.length / 2));
			for (i in 0...newBuffer.length) {
    			newBuffer[i] = input.readInt16() / 32768.0;
			}
		}
        else if (buffer.bitsPerSample == 24) {
			var input = new haxe.io.BytesInput(buffer.data.toBytes());
            newBuffer.resize(Std.int(buffer.data.length / 3));
			for (i in 0...newBuffer.length) {
    			newBuffer[i] = input.readInt24() / 8388608.0;
			}
		}
        else if (buffer.bitsPerSample == 32) {
			var bytes = buffer.data.toBytes();
            newBuffer.resize(Std.int(buffer.data.length / 4));
			for (i in 0...newBuffer.length) {
    			newBuffer[i] = bytes.getInt32(i * 4) / 2147483648.0;
			}
		}
        else {
            trace('Unknown integer audio format');
        }
        return newBuffer;
    }
}

#end