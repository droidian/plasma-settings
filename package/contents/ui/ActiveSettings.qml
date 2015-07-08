/***************************************************************************
 *                                                                         *
 *   Copyright 2011-2014 Sebastian Kügler <sebas@kde.org>                  *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

Rectangle {
    id: rootItem

    width: 400
    height: 600
    color: theme.backgroundColor

    property string formFactor: startFormFactor != "" ? startFormFactor : "handset" // overridden by --formfactor argument!


    property bool loading: false
    property bool compactMode: width < units.gridUnit * 30

    property string currentModule: ""

    onCurrentModuleChanged: {
        if (rootItem.compactMode) {
            appBackground.x = - rootItem.width
        }
    }

    onCompactModeChanged: {
        if (!compactMode) {
            appBackground.x = 0;
        }
    }

    function loadModule(mod) {
        print("Loading module." + mod);
        rootItem.currentModule = mod;
        settingsItem.module = mod;
    }

    Item {
        id: appBackground

        anchors {
            top: parent.top
            bottom: toolBar.top
        }
        width: rootItem.compactMode ? rootItem.width * 2 : rootItem.width
        Behavior on x {
            enabled: rootItem.compactMode
            PropertyAnimation {
                duration: units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }

        Item {
            id: settingsRoot
            objectName: "settingsRoot"
            state: "expanded"
            anchors.fill: parent

            property bool loading: false

            signal loadPlugin(string module);

            AppHeader {
                id: header
                anchors {
                    margins: units.gridUnit
                    bottomMargin: 0
                    top: parent.top
                    left: modulesList.right
                    right: settingsItem.right
                }
            }

            Item {
                id: navheader
                visible: compactMode

                height: childrenRect.height
                anchors {
                    margins: units.gridUnit
                    bottomMargin: 0
                    top: parent.top
                    left: parent.left
                    right: modulesList.right
                }
                PlasmaCore.IconItem {
                    id: topIcon
                    width: units.gridUnit * 2
                    height: width
                    opacity: loadingIndicator.running ? 0 : 1.0
                    Behavior on opacity { NumberAnimation { duration: units.shortDuration } }
                    source: "preferences-desktop"
                    anchors {
                        verticalCenter: title.verticalCenter
                        right: parent.right
                        margins: units.gridUnit
                        rightMargin: 0
                    }
                }

                PlasmaComponents.BusyIndicator {
                    id: loadingIndicator
                    anchors.fill: topIcon
                    opacity: running ? 1.0 : 0
                    Behavior on opacity { NumberAnimation { duration: units.shortDuration } }
                    running: settingsRoot.loading
                }

                PlasmaExtras.Title {
                    id: title
                    anchors {
                        left: parent.left
                        right: topIcon.left
                    }
                    elide: Text.ElideRight
                    text: i18n("Settings")
                    /*
                    // This is used for testing formfactor formfactor changes
                    // if it annoys you, kill it. :P
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (rootItem.formFactor == "") {
                                rootItem.formFactor = "handset"
                            } else {
                                rootItem.formFactor = "";
                            }
                            print("formfactor is now " + rootItem.formFactor)
                        }
                    }
                    */

                }

                PlasmaCore.SvgItem {
                    svg: PlasmaCore.Svg {imagePath: "widgets/line"}
                    elementId: "horizontal-line"
                    height: naturalSize.height
                    anchors {
                        top: title.bottom
                        topMargin: units.gridUnit / 2
                        left: parent.left
                        right: parent.right
                        leftMargin: -units.gridUnit
                        rightMargin: -units.gridUnit
                    }
                }
            }

            Item {
                id: modulesList
                z: 800

                property alias currentIndex: mlist.currentIndex

                anchors.top: compactMode ? navheader.bottom : parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: rootItem.compactMode ? rootItem.width : Math.min(units.gridUnit * 15, parent.width/3)

                ModulesList {
                    id: mlist
                    anchors.fill: parent
                }
            }

            Component {
                id: initial_page
                Item {
                    visible: startModule == ""
                    anchors { fill: parent; margins: units.gridUnit * 4; }
                    PlasmaCore.IconItem {
                        source: "preferences-desktop"
                        anchors { top: parent.top; right: parent.right; }
                        opacity: 0.1
                        width: 256
                        height: width
                    }
                }
            }

            ModuleItem {
                id: settingsItem

                anchors {
                    leftMargin: units.gridUnit
                    top: header.bottom
                    bottom: parent.bottom
                    left: modulesList.right
                    right: parent.right
                }
            }
        }

        Component.onCompleted: {
            if (startModule != "") {
                loadModule(startModule);
            }
        }
    }
    PlasmaComponents.ToolBar {
        id: toolBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        visible: rootItem.compactMode
        opacity: enabled ? 1 : 0
        Behavior on opacity { NumberAnimation {} }
        enabled: appBackground.x < 0
        tools: Row {
            PlasmaComponents.ToolButton {
                iconSource: "go-previous"
                onClicked: {
                    rootItem.currentModule = "";
                    appBackground.x = 0;
                    //modulesList.currentIndex = -1
                    rootItem.state = "navigation";
                }
            }
        }
    }

    states: [
        State {
            name: "navigation"
            when: (compactMode && appBackground.x == 0) || (rootItem.currentModule == "")
        },
        State {
            name: "module"
            when: (compactMode && appBackground.x != 0) || (rootItem.currentModule != "")
        }
    ]

}