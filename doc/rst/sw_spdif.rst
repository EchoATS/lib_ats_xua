
|newpage|

S/PDIF transmit
===============

``lib_xua`` supports the development of devices with S/PDIF transmit through the use of
`lib_spdif <https://www.xmos.com/file/lib_spdif>`__.
The `XMOS` S/SPDIF transmitter component runs in a single thread and supports sample-rates upto 192
kHz.

The S/PDIF transmitter thread takes PCM audio samples via a channel and outputs them
in S/PDIF format to a port.  A lookup table is used to encode the audio data into the required format.

It receives samples from the Audio I/O thread two at a time (for left and right). For each sample,
it performs a lookup on each byte, generating 16 bits of encoded data which it outputs to a port.

S/PDIF sends data in frames, each containing 192 samples of the left and right channels.

Audio samples are encapsulated into S/PDIF words (adding preamble, parity, channel status and validity
bits) and transmitted in biphase-mark encoding (BMC) with respect to an *external* master clock.

.. list-table:: S/PDIF capabilities

   * - **Sample frequencies**
     - 44.1, 48, 88.2, 96, 176.4, 192 kHz
   * - **Master clock ratios**
     - 128x, 256x, 512x
   * - **Library**
     - ``lib_spdif``

Clocking
--------

.. only:: latex

 .. _spdif_clocking_jitter_reduction:

 .. figure:: images/spdif.pdf

   D-Type Jitter Reduction

.. only:: html

 .. figure:: images/spdif.png

   D-Type jitter reduction


The S/PDIF signal is output at a rate dictated by the external master clock. The master clock must
be 1x 2x or 4x the BMC bit rate (that is 128x 256x or 512x audio sample rate, respectively).
For example, the minimum master clock frequency for 192kHz is therefore 24.576 MHz.

This resamples the master clock to its clock domain (oscillator), which introduces jitter of 2.5-5
ns on the S/PDIF signal. A typical jitter-reduction scheme is an external D-type flip-flop clocked
from the master clock (as shown in :numref:`spdif_clocking_jitter_reduction`).

Usage
-----

The interface to the S/PDIF transmitter thread is via a normal channel using streaming builtin
functions (``outuint``, ``inuint``).
Data format should be 24-bit left-aligned in a 32-bit word: ``0x12345600``

The following protocol is used on the channel:

.. list-table:: S/PDIF Component Protocol

  * - ``outct``
    -  New sample rate command
  * - ``outuint``
    - Sample frequency (Hz)
  * - ``outuint``
    - Master clock frequency (Hz)
  * - ``outuint``
    - Left sample
  * - ``outuint``
    - Right sample
  * - ``outuint``
    - Left sample
  * - ``outuint``
    - Right sample
  * - ``...``
    -
  * - ``...``
    -

This communication is wrapped up in the API functions provided by ``lib_spdif``.

Output stream structure
-----------------------

The stream is composed of words with the structure shown in
:numref:`usb_audio_spdif_stream_structure`. The channel status bits are
0x0nc07A4, where c=1 for left channel, c=2 for right channel and n
indicates sampling frequency as shown in :numref:`usb_audio_spdif_sample_bits`.

.. _usb_audio_spdif_stream_structure:

.. list-table:: S/PDIF stream structure
     :header-rows: 1
     :widths: 10 32 58

     * - Bits
       -
       -
     * - 0:3
       - Preamble
       - Correct B M W order, starting at sample 0
     * - 4:27
       - Audio sample
       - Top 24 bits of given word
     * - 28
       - Validity bit
       - Always 0
     * - 29
       - Subcode data (user bits)
       - Unused, set to 0
     * - 30
       - Channel status
       - See below
     * - 31
       - Parity
       - Correct parity across bits 4:30


.. _usb_audio_spdif_sample_bits:

.. list-table:: Channel status bits
  :header-rows: 1

  * - Frequency (kHz)
    - n
  * - 44.1
    - 0x0
  * - 48
    - 0x2
  * - 88.2
    - 0x8
  * - 96
    - 0xA
  * - 176.4
    - 0xC
  * - 192
    - 0xE

