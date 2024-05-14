package grig.audio;

/*
 * util.c
 * Copyright 2009-2019 John Lindgren and Michał Lipski
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

class FFTVisualization
{
    private static function computeLogXScale(bands:Int):Array<Float> {
        var xscale = new Array<Float>();
        xscale.resize(bands);
        for (i in 0...bands)
            xscale[i] = Math.pow(256, i / bands) - 0.5;
        return xscale;
    }

    private static function computeFreqBand(freq:Array<Float>, xscale:Array<Float>, band:Int, bands:Int):Float {
        var a:Int = Math.ceil(xscale[band]);
        var b:Int = Math.floor(xscale[band + 1]);
        var n:Float = 0.0;

        if (b < a)
            n += freq[b] * (xscale[band + 1] - xscale[band]);
        else {
            if (a > 0)
                n += freq[a - 1] * (a - xscale[band]);
            while (a < b) {
                n += freq[a];
                a++;
            }
            if (b < 256)
                n += freq[b] * (xscale[band + 1] - b);
        }

        // fudge factor to make the graph have the same overall height as a
        // 12-band one no matter how many bands there are
        n *= bands / 12;

        return 20 * FFT.log(10, n);
    }

    // template <typename T, typename T2>
    // static inline T clamp(T2 value, T lower, T upper)
    // {
    // return value < lower ? lower : (value > upper ? upper : value);
    // }

    // void make_log_graph (const float * freq, int bands, int db_range,
    // int int_range, unsigned char * graph)
    // {
    //     static int last_bands = 0;
    //     static vector<float> xscale;

    //     /* conversion table for the x-axis */
    //     if (bands != last_bands)
    //     {
    //         xscale.resize (bands + 1);
    //         compute_log_xscale (& xscale[0], bands);
    //         last_bands = bands;
    //     }

    //     for (int i = 0; i < bands; i ++)
    //     {
    //         float val = compute_freq_band (freq, & xscale[0], i, bands);
    //         /* scale (-db_range, 0.0) to (0.0, int_range) */
    //         val = (1 + val / db_range) * int_range;
    //         graph[i] = clamp ((int) val, 0, int_range);
    //     }
    // }
}