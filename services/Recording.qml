pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool active: false;

    reloadableId: "recording"

    FileView {
        path: "/tmp/.recording-status"
        watchChanges: true
        onFileChanged: {
          root.active = false;
          reload()
        }
        onLoaded: {
            root.active = text().trim() === "true";
        }
    }


    function toggle(): void {
      Quickshell.execDetached(["/run/current-system/sw/bin/record", "toggle-recording"]);
    }
}
