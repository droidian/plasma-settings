set(timesettings_SRCS
    timesettings.cpp
    timezonemodel.cpp
    timezonesi18n.cpp
)

qt_add_dbus_interface(timesettings_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/timedated1.xml timedated_interface)

add_library(kcm_mobile_time MODULE ${timesettings_SRCS})

target_link_libraries(kcm_mobile_time
    Qt5::Quick
    Qt5::Qml
    Qt5::DBus
    KF5::QuickAddons
    KF5::ConfigCore
    KF5::I18n
    )

# Time and Date

install(TARGETS kcm_mobile_time DESTINATION ${KDE_INSTALL_QTPLUGINDIR}/kcms)
kpackage_install_package(package kcm_mobile_time kcms)
