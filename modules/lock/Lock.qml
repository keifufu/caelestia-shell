pragma ComponentBehavior: Bound

import qs.widgets
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    LazyLoader {
        id: loader

        WlSessionLock {
            id: lock

            property bool unlocked

            locked: true

            onLockedChanged: {
                if (!locked)
                    loader.active = false;
            }

            LockSurface {
                lock: lock
            }
        }
    }

    function uptime(seconds: int) {
      // Show lockscreen on system startup
      // if (seconds < 90 && !loader.actuvactive) loader.activeAsync = true;
    }

    Process {
        id: uptimeProc

        running: true
        command: ["sh", "-c", "cut -d. -f1 /proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: uptime(parseInt(text))
        }
    }

    CustomShortcut {
        name: "lock"
        description: "Lock the current session"
        onPressed: loader.activeAsync = true
    }

    CustomShortcut {
        name: "unlock"
        description: "Unlock the current session"
        onPressed: loader.item.locked = false
    }

    IpcHandler {
        target: "lock"

        function lock(): void {
            loader.activeAsync = true;
        }

        function unlock(): void {
            loader.item.locked = false;
        }

        function isLocked(): bool {
            return loader.active;
        }
    }
}
