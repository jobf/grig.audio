package;

import grig.audio.FFT;
import tink.unit.Assert.*;

@:asserts
@:access(grig.audio.FFT)
class FFTTest
{
    private static final delta = 0.0001;

    public function new() {
    }

    public function testInit() {
        var a = new FFT(512);

        asserts.assert(Math.abs(a.hamming[12] - 0.1592) < delta);
        asserts.assert(Math.abs(a.hamming[76] - 0.493656) < delta);

        asserts.assert(a.reversed[24] == 48);
        asserts.assert(a.reversed[56] == 56);

        var c1 = a.roots[15];
        asserts.assert(Math.abs(c1.real - 0.983105) < delta);
        asserts.assert(Math.abs(c1.imag - 0.18304) < delta);

        var c2 = a.roots[72];
        asserts.assert(Math.abs(c2.real - 0.634393) < delta);
        asserts.assert(Math.abs(c2.imag - 0.77301) < delta);

        return asserts.done();
    }
}