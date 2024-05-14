package grig.audio;

/*
 * fft.c
 * Copyright 2011 John Lindgren
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions, and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions, and the following disclaimer in the documentation
 *    provided with the distribution.
 *
 * This software is provided "as is" and without any warranty, express or
 * implied. In no event shall the authors be liable for any damages arising from
 * the use of this software.
 */

// Original c code copyright 2011 John Lindgren, ported to haxe by Thomas J. Webb 2024

class FFT
{
    private static final TWO_PI:Float = 6.2831853;

    private var hamming = new Array<Float>();
    private var reversed = new Array<Int>();
    private var roots = new Array<Complex>();
    private var n:Int;
    private var logN:Int;

    public function new(n:Int = 512) {
        hamming.resize(n);
        reversed.resize(n);
        roots.resize(Std.int(n / 2));

        this.n = n;
        logN = Std.int(log(2.0, n));
        generateTables();
    }

    public static function log(base:Float, x:Float):Float {
        return Math.log(x) / Math.log(base);
    }

    private function bitReverse(x:Int):Int {
        var y:Int = 0;

        var i:Int = logN;
        while (i > 0) {
            y = (y << 1) | (x & 1);
            x >>= 1;
            i--;
        }

        return y;
    }

    private function generateTables() {
        // for (int n = 0; n < N; n++)
        //     hamming[n] = 1 - 0.85f * cosf(n * (TWO_PI / N));
        // for (int n = 0; n < N; n++)
        //     reversed[n] = bit_reverse(n);
        // for (int n = 0; n < N / 2; n++)
        //     roots[n] = exp(Complex(0, n * (TWO_PI / N)));

        for (i in 0...n)
            hamming[i] = 1 - 0.85 * Math.cos(i * (TWO_PI / n));
        for (i in 0...reversed.length)
            reversed[i] = bitReverse(i);
        for (i in 0...Std.int(n / 2))
            roots[i] = Complex.exp(new Complex(0, i * (TWO_PI / n)));
    }
}