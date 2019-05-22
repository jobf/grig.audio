package grig.audio.format.wav;

#if (js && !nodejs)
typedef Reader = grig.audio.js.webaudio.Reader;
#elseif format

import format.wav.Data;
import haxe.io.Input;
import grig.audio.AudioChannel;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;

class Reader
{
    private var input:Input;

    public function new(_input:Input)
    {
        input = _input;
    }

    public function load():Surprise<AudioBuffer, tink.core.Error>
    {
        return Future.async(function(_callback) {
            try {
                var reader = new format.wav.Reader(input);
                var wav = reader.read();
                var lengthPerChannel:Int = Math.ceil(wav.data.length / wav.header.channels / (wav.header.bitsPerSample / 8));
                var buffer = AudioBuffer.create(wav.header.channels, lengthPerChannel, wav.header.samplingRate);
                var bytesInput = new haxe.io.BytesInput(wav.data);
                for (i in 0...lengthPerChannel) {
                    for (c in 0...buffer.channels.length) {
                        // Assuming integer file format here
                        buffer.channels[c][i] = if (wav.header.bitsPerSample == 8) {
                            bytesInput.readByte() / 255.0;
                        } else if (wav.header.bitsPerSample == 16) {
                            bytesInput.readInt16() / 32767.0;
                        } else if (wav.header.bitsPerSample == 24) {
                            bytesInput.readInt24() / 8388607.0;
                        } else if (wav.header.bitsPerSample == 32) {
                            bytesInput.readInt32() / 2147483647.0;
                        } else {
                            throw 'Unknown format: ${wav.header.bitsPerSample}';
                        }
                    }
                }
                _callback(Success(buffer));
            }
            catch (error:Error) {
                _callback(Failure(new Error(InternalError, 'Failed to load audio data. ${error.message}')));
            }
        });
    }
}

#else
#error "Requires either js/html environment or format haxelib"
#end