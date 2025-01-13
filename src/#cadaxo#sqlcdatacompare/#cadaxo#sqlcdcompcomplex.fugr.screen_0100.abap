PROCESS BEFORE OUTPUT.

  module pbo_0100.

  CALL SUBSCREEN subscreen_area INCLUDING sy-repid g_subscreen.
*
PROCESS AFTER INPUT.

  CALL SUBSCREEN subscreen_area.

  module pai_0100.
