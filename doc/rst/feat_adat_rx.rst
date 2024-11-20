|newpage|

ADAT receive
============

``lib_xua`` supports the development of devices with ADAT receive functionality through the use of
`lib_adat <https://www.xmos.com/file/lib_adat>`__. The `XMOS` ADAT receiver runs on a single thread.

The ADAT receive component receives up to eight channels of audio at a sample rate
of 44.1kHz or 48kHz. The API for calling the receiver functions is
described in the `ADAT receive example in lib_adat <https://github.com/xmos/lib_adat/tree/develop/examples/app_adat_rx_example>`_ .

The component outputs 32 bits words split into nine word frames. The
frames are laid out in the following manner:

  * Control byte
  * Channel 0 sample
  * Channel 1 sample
  * Channel 2 sample
  * Channel 3 sample
  * Channel 4 sample
  * Channel 5 sample
  * Channel 6 sample
  * Channel 7 sample

An example of how to read the output of the ADAT component is shown below::

  control = inuint(oChan);

  for(int i = 0; i < 8; i++)
  {
      sample[i] = inuint(oChan);
  }

Samples are 24-bit values contained in the lower 24 bits of the word.

The control word comprises four control bits in bits [11..8] and the value 0b00000001 in bits [7..0].
This control word enables synchronization at a higher level, in that, on the channel, a single odd
word is always read followed by eight words of data.

Usage and integration
---------------------

Since the ADAT is a digital stream the device's master clock must be synchronised to it. The integration
of ADAT receive is much the same as S/PDIF receive in that the ADAT receive function communicates
with the `Clock Gen` thread. This `Clock Gen` thread then passes audio data onto the Audio Hub thread.
It also handles locking to the ADAT clock source.

There are some small differences with the S/PDIF integration accounting for the fact that ADAT
typically has 8 channels compared to S/PDIF's two.

The `Clock Gen` thread also handles SMUX II (e.g. 4 channels at 96kHz) and SMUX IV (e.g. 2 channels at
192 kHz), populating the sample FIFO as appropriate. SMUX modes are communicated to the `Clock Gen`
thread from Endpoint 0 via the ``c_clk_ctl`` channel.  SMUX modes are exposed to the USB host using
Alternative Interfaces, with appropriate channel counts, for the streaming input Endpoint.

