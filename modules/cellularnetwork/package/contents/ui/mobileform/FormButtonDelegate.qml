/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.19 as Kirigami

AbstractFormDelegate {
    id: root
    
    property string text: ""
    property string description: ""
    property string iconName: ""
    
    Layout.fillWidth: true
    
    contentItem: RowLayout {
        Kirigami.Icon {
            visible: root.iconName !== ""
            source: root.iconName
            Layout.rightMargin: (root.iconName !== "") ? Kirigami.Units.largeSpacing : 0
            implicitWidth: (root.iconName !== "") ? Kirigami.Units.iconSizes.small : 0
            implicitHeight: (root.iconName !== "") ? Kirigami.Units.iconSizes.small : 0
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            
            Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                color: root.enabled ? Kirigami.Theme.textColor : Kirigami.Theme.disabledTextColor
            }
            
            Label {
                Layout.fillWidth: true
                text: root.description
                color: Kirigami.Theme.disabledTextColor
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
                visible: root.description !== ""
            }
        }
        
        Kirigami.Icon {
            Layout.alignment: Qt.AlignRight
            source: "arrow-right"
            implicitWidth: Kirigami.Units.iconSizes.small
            implicitHeight: Kirigami.Units.iconSizes.small
        }
    }
}
