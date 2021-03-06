ifneq ($(TARGET_BUILD_VARIANT),user)
MIXIN_DEBUG_NPK := true
endif

ifeq ($(MIXIN_DEBUG_NPK),true)

PRODUCT_COPY_FILES += \
{{#treble}}
    $(LOCAL_PATH)/{{_extra_dir}}/init.npk.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.npk.rc \
{{/treble}}
{{^treble}}
    $(LOCAL_PATH)/{{_extra_dir}}/init.npk.rc:root/init.npk.rc \
{{/treble}}
    $(LOCAL_PATH)/{{_extra_dir}}/npk_{{platform}}.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/npk.cfg
PRODUCT_PACKAGES += \
    npk_init \
    logd2sven

# Enable redirection of android logs to SVENTX
LOGCATEXT_USES_SVENTX := true
BOARD_SEPOLICY_DIRS += \
    $(INTEL_PATH_SEPOLICY)/debug-npk

ifeq ($(PSTORE_CONFIG),PRAM)

# Default configuration for dumps to pstore
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.vendor.npk.cfg={{default_cfg}}

# Increase pstore dump size to fit MSC buffers
BOARD_KERNEL_CMDLINE += \
    intel_pstore_pram.record_size=524288 \
    pstore.extra_size=524288

endif # PSTORE_CONFIG == PRAM

endif #MIXIN_DEBUG_NPK

{{#tcf_conf}}
ifeq ($(MIXIN_DEBUG_NPK),true)
BOARD_SEPOLICY_DIRS += \
    $(INTEL_PATH_SEPOLICY)/debug-npk/tcf

PRODUCT_PACKAGES += npk_tcf_services
endif #MIXIN_DEBUG_NPK
{{/tcf_conf}}
