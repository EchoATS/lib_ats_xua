|newpage|

USB Audio Class version
=======================

The codebase supports USB Audio Class versions 1.0 and 2.0.

USB Audio Class 2.0 offers many improvements over USB Audio Class 1.0, most notable is the complete
support for high-speed operation.  This means that Audio Class devices are no longer limited to
full-speed operation allowing greater channel counts, sample frequencies and sample bit-depths.
Additional improvements, amongst others, include:

- Added support for multiple clock domains, clock description and clock control

- Extensive support for interrupts to inform the host about dynamic changes that occur to different entities such as Clocks etc

Driver Support
--------------

Audio Class 1.0
^^^^^^^^^^^^^^^

 - Audio Class 1.0 is fully supported in Apple macOS.
 - Audio Class 1.0 is fully supported in all modern Microsoft Windows operating systems (i.e. Windows XP and later).

Audio Class 2.0
^^^^^^^^^^^^^^^

 - Audio Class 2.0 is fully supported in Apple macOS since version 10.6.4.
 - Starting with Windows 10, release 1703, a USB Audio 2.0 driver is shipped with Windows.

Third party Windows drivers are also available, however, documentation of these is beyond the scope of this document, please contact `XMOS` for further details.

Audio Class 1.0 mode and fall-back
----------------------------------

The default for `XMOS` USB Audio applications is to run as a high-speed Audio Class 2.0
device. However, some products may prefer to run in Audio Class 1.0 mode, this is normally to
allow "driver-less" operation with older versions of Windows operating systems or some embedded hosts.

.. note::

    To ensure specification compliance, Audio Class 1.0 mode *always* operates at full-speed USB.

The device will operate in full-speed Audio Class 1.0 mode if one of the following is true:

-  The code is compiled for USB Audio Class 1.0 only.

-  The code is compiled for USB Audio Class 2.0 and it is connected
   to the host over a full speed link (and the Audio Class fall back is
   enabled).

The options to control this behavior are detailed in :ref:`sec_api_defines`.

Due to bandwidth limitations of full-speed USB the following sample-frequency restrictions are also applied:

-  Sample rate is limited to a maximum of 48kHz if both input and output are enabled.

-  Sample rate is limited to a maximum of 96kHz if only input *or* output is enabled.


Related Defines
---------------

:numref:`opt_audio_class_defines` describes the defines that affect audio class selection:

.. _opt_audio_class_defines:

.. list-table:: Audio Class defines
   :header-rows: 1
   :widths: 40 40 30

   * - Define
     - Description
     - Default
   * - ``AUDIO_CLASS``
     - Audio Class version (1 or 2)
     - N/A (*must* be defined)
   * - ``AUDIO_CLASS_FALLBACK``
     - Enable audio class fallback functionality
     - ``0`` (disabled)

.. warning::

    Enabling USB Audio Class fallback functionality may have USB Compliance implications

