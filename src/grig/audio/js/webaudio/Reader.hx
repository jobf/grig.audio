package grig.audio.js.webaudio; #if (js && !nodejs)

import haxe.io.Input;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;

import format.wav.Data;
import haxe.io.Input;
import grig.audio.AudioChannel;
import grig.audio.NumericTypes;
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
                
                var bytes = input.readAll();
                if(AudioInterface.audioContext != null){
                    AudioInterface.audioContext.decodeAudioData(bytes.getData(), function(buffer:js.html.audio.AudioBuffer) {
                        var reader = new format.wav.Reader(input);
                        var wav = reader.read();
                        var lengthPerChannel:Int = Math.ceil(wav.data.length / wav.header.channels / (wav.header.bitsPerSample / 8));
                        var buffer = new AudioBuffer(wav.header.channels, lengthPerChannel, wav.header.samplingRate);
                        var bytesInput = new haxe.io.BytesInput(wav.data);
                        // We could use that we have int buffers now to find a more
                        // efficient way of doing this
                        for (i in 0...lengthPerChannel) {
                            for (c in 0...buffer.numChannels) {
                                // Assuming integer file format here
                                buffer[c][i] = if (wav.header.bitsPerSample == 8) {
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
                    }, function(error:js.html.DOMException) {
                        _callback(Failure(new Error(InternalError, 'Failed to load audio data. ${error.message}')));
                    });
                }
                
            }
            catch (error:Error) {
                _callback(Failure(new Error(InternalError, 'Failed to load audio data. ${error.message}')));
            }
        });
    }
    
    // public function load_():Surprise<AudioBuffer<Float32>, tink.core.Error>
    //     {
    //         return Future.async(function(_callback) {
    //             try {
    //                 var reader = new format.wav.Reader(input);
    //                 var wav = reader.read();
    //                 var lengthPerChannel:Int = Math.ceil(wav.data.length / wav.header.channels / (wav.header.bitsPerSample / 8));
    //                 var buffer = new AudioBuffer<Float32>(wav.header.channels, lengthPerChannel, wav.header.samplingRate);
    //                 var bytesInput = new haxe.io.BytesInput(wav.data);
    //                 // We could use that we have int buffers now to find a more
    //                 // efficient way of doing this
    //                 for (i in 0...lengthPerChannel) {
    //                     for (c in 0...buffer.numChannels) {
    //                         // Assuming integer file format here
    //                         buffer[c][i] = if (wav.header.bitsPerSample == 8) {
    //                             bytesInput.readByte() / 255.0;
    //                         } else if (wav.header.bitsPerSample == 16) {
    //                             bytesInput.readInt16() / 32767.0;
    //                         } else if (wav.header.bitsPerSample == 24) {
    //                             bytesInput.readInt24() / 8388607.0;
    //                         } else if (wav.header.bitsPerSample == 32) {
    //                             bytesInput.readInt32() / 2147483647.0;
    //                         } else {
    //                             throw 'Unknown format: ${wav.header.bitsPerSample}';
    //                         }
    //                     }
    //                 }
    //                 _callback(Success(buffer));
    //             }
    //             catch (error:Error) {
    //                 _callback(Failure(new Error(InternalError, 'Failed to load audio data. ${error.message}')));
    //             }
    //         });
    //     }
}

#end


