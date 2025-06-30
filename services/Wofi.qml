pragma Singleton

import "root:/utils/scripts/fuzzysort.js" as Fuzzy
import Quickshell

Singleton {
    id: root

    property bool isOpen: false;
    property list<var> options: []
    property string icon: "open_in_new"
    property string command: ""

    function fuzzyQuery(search: string): list<var> {
        return Fuzzy.go(search, options, {
            all: true,
            keys: ["name"],
        }).map(r => r.obj);
    }

    function exec(option: var): void {
        Quickshell.execDetached(["bash", "-c", command.replace("@VALUE@", option.value)]);
    }
}
