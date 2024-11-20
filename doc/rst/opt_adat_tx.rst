|newpage|

ADAT transmit
=============

The codebase supports a single ADAT transmitter that can transmit
eight channels of uncompressed digital audio at sample-rates of 44.1 or 48 kHz over an optical cable.
Higher rates are supported with a reduced number of samples via S/MUX (‘sample multiplexing’). Using S/MUX,
the ADAT transmitter can transmit four channels at 88.2 or 96 kHz or two channels at 176.4 or 192 kHz.

In order to provide ADAT transmit functionality ``lib_xua`` uses `lib_adat <https://www.xmos.com/file/lib_adat>`_.

Basic configuration of ADAT transmit functionality is achieved with the defines in
:numref:`opt_adat_tx_defines`.

|beginfullwidth|

.. _opt_adat_tx_defines:

.. list-table:: ADAT transmit defines
   :header-rows: 1
   :widths: 35 40 40

   * - Define
     - Description
     - Default
   * - ``XUA_ADAT_TX_EN``
     - Enable ADAT transmit
     - ``0`` (Disabled)
   * - ``ADAT_TX_INDEX``
     - Start channel index of ADAT TX channels
     - N/A (must be defined by the application)
   * - ``ADAT_TX_USE_SHARED_BUFF``
     - Use shared memory when transferring samples between AudioHub and the ADAT tansmitter task
     - N/A (must be defined by the application)

|endfullwidth|

The ADAT transmitter runs on the same tile as the Audio IO (``AUDIO_IO_TILE``)

The codebase expects the ADAT transmit port to be defined in the application XN file as ``PORT_ADAT_OUT``.
This must be a 1-bit port, for example::

    <Port Location="XS1_PORT_1G"  Name="PORT_ADAT_OUT"/>
