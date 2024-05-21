package grig.audio;

#if lime

using grig.audio.BytesTools;

class LimeUtils
{
    public static function uint8ArrayToInterleaved(data:lime.utils.UInt8Array, bitsPerSample:Int):Array<Float> {
        var newBuffer = new Array<Float>();
        if (bitsPerSample == 8) {    
            newBuffer.resize(data.length);
			for (i in 0...data.length) {
				newBuffer[i] = data[i] / 128.0;
			}
		}
		else if (bitsPerSample == 16) {
            newBuffer.resize(Std.int(data.length / 2));
			var bytes = data.toBytes();
			for (i in 0...newBuffer.length) {
    			newBuffer[i] = bytes.getInt16(i * 2) / 32767.0;
			}
		}
        else if (bitsPerSample == 24) {
			var bytes = data.toBytes();
            newBuffer.resize(Std.int(data.length / 3));
			for (i in 0...newBuffer.length) {
    			newBuffer[i] = bytes.getInt24(i * 3) / 8388607.0;
			}
		}
        else if (bitsPerSample == 32) {
			var bytes = data.toBytes();
            newBuffer.resize(Std.int(data.length / 4));
			for (i in 0...newBuffer.length) {
    			newBuffer[i] = bytes.getInt32(i * 4) / 2147483647.0;
			}
		}
        else {
            trace('Unknown integer audio format');
        }
        return newBuffer;
    }

	public static function limeAudioBufferToInterleaved(buffer:lime.media.AudioBuffer):Array<Float> {
		return uint8ArrayToInterleaved(buffer.data, buffer.bitsPerSample);
	}
}

#end