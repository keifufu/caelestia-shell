import qs.widgets
import qs.services
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property bool launcherInterrupted

    CustomShortcut {
        name: "showall"
        description: "Toggle launcher, dashboard and osd"
        onPressed: {
            const v = Visibilities.getForActive();
            v.launcher = v.dashboard = v.osd = v.utilities = !(v.launcher || v.dashboard || v.osd || v.utilities);
        }
    }

    CustomShortcut {
        name: "launcher"
        description: "Toggle launcher"
        onPressed: root.launcherInterrupted = false
        onReleased: {
            if (!root.launcherInterrupted) {
                const visibilities = Visibilities.getForActive();
                visibilities.launcher = !visibilities.launcher;
            }
            root.launcherInterrupted = false;
        }
    }

    CustomShortcut {
        name: "launcherInterrupt"
        description: "Interrupt launcher keybind"
        onPressed: root.launcherInterrupted = true
    }

    IpcHandler {
        target: "drawers"

        function toggle(drawer: string): void {
            if (list().split("\n").includes(drawer)) {
                const visibilities = Visibilities.getForActive();
                visibilities[drawer] = !visibilities[drawer];
            } else {
                console.warn(`[IPC] Drawer "${drawer}" does not exist`);
            }
        }

        function list(): string {
            const visibilities = Visibilities.getForActive();
            return Object.keys(visibilities).filter(k => typeof visibilities[k] === "boolean").join("\n");
        }
    }

    IpcHandler {
        target: "wofi"

        function toggle(values: string, names: string, icon: string, command: string): void {
            const visibilities = Visibilities.getForActive();
            const split_names = names.split("@SEP@");
            Wofi.options = values.split("@SEP@").map((v, i) => ({
              value: v,
              name: split_names[i],
            }));
            Wofi.icon = icon;
            Wofi.command = command;
            Wofi.isOpen = true;
            visibilities.launcher = !visibilities.launcher;
        }
    }
}
