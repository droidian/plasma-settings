set (cellularnetworksettings_SRCS 
    cellularnetworksettings.cpp 
    modem.cpp
    modemdetails.cpp
    sim.cpp
    mobileproviders.cpp
)

add_library(kcm_cellular_network MODULE ${cellularnetworksettings_SRCS})

target_link_libraries(kcm_cellular_network
    Qt5::DBus
    Qt5::Gui
    Qt5::Quick
    Qt5::Qml
    Qt5::Xml
    KF5::Plasma
    KF5::I18n
    KF5::NetworkManagerQt
    KF5::ModemManagerQt
    KF5::QuickAddons
)

install(TARGETS kcm_cellular_network DESTINATION ${PLUGIN_INSTALL_DIR}/kcms)
kpackage_install_package(package kcm_cellular_network kcms)
