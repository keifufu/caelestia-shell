pragma Singleton

import qs.config
import qs.utils
import Quickshell

Searcher {
    id: root

    list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    useFuzzy: Config.launcher.useFuzzy.apps

    function launch(entry: DesktopEntry): void {
        if (entry.runInTerminal)
            Quickshell.execDetached({
                command: ["uwsm app", "--", "foot", `${Quickshell.configDir}/assets/wrap_term_launch.sh`, ...entry.command],
                workingDirectory: entry.workingDirectory
            });
        else
            Quickshell.execDetached({
                command: ["uwsm", "app", "--", ...entry.command],
                workingDirectory: entry.workingDirectory
            });
    }
}
