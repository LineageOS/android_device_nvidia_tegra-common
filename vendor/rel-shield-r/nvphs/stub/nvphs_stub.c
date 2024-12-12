/*
 * Copyright (c) 2013-2018, NVIDIA CORPORATION.  All rights reserved.
 * Copyright (c) 2024 Thomas Makin
 *
 * NVIDIA CORPORATION and its licensors retain all intellectual property
 * and proprietary rights in and to this software, related documentation
 * and any modifications thereto.  Any use, reproduction, disclosure or
 * distribution of this software and related documentation without an express
 * license agreement from NVIDIA CORPORATION is strictly prohibited
 */

#include <stdint.h>

typedef enum
{
    NvUsecase_NULL          = 0x00000000,
    NvUsecase_FIRST         = 0x00000001,

    NvUsecase_generic       = 0x00000001,
    NvUsecase_graphics      = 0x00000002,
    NvUsecase_camera        = 0x00000004,
    NvUsecase_video         = 0x00000008,
    NvUsecase_gpucompute    = 0x00000010,
    NvUsecase_ui            = 0x00000020,

    NvUsecase_LAST          = NvUsecase_ui,
    NvUsecase_ANY           = 0x7fffffff,
    NvUsecase_Force32       = 0x7fffffff
} NvUsecase;

typedef enum
{
    NvHintType_FIRST                = 0,

    NvHintType_ThroughputHint       = 0,
    NvHintType_FramerateTarget      = 1,
    NvHintType_MinCPU               = 2,
    NvHintType_MaxCPU               = 3,
    NvHintType_MinGPU               = 4,
    NvHintType_MaxGPU               = 5,
    NvHintType_GPUComputation       = 6,
    NvHintType_FramerateMinimum     = 7,
    NvHintType_AppIdletime          = 8,
    NvHintType_EglAvgFrameProctime  = 9,
    NvHintType_EglMaxFrameProctime  = 10,
    NvHintType_EglFrameTimestamp    = 11,
    NvHintType_EglBufferQueueLength = 12,
    NvHintType_CaptureQueueSize     = 13,
    NvHintType_TransientCpuLoad     = 14,
    NvHintType_CpuFloorVmin         = 15,
    NvHintType_GpuFloorVmin         = 16,
    NvHintType_CpuFloorCamera       = 17,
    NvHintType_GpuFloorCamera       = 18,
    NvHintType_GlsiFrameTimestamp   = 19,
    NvHintType_CameraFrameTimestamp = 20,

    NvHintType_COUNT,
    NvHintType_LAST                 = NvHintType_COUNT-1,
    NvHintType_LastReserved         = 63,
    NvHintType_Force32              = 0x7FFFFFFF
} NvHintType;

typedef enum
{
    NvProcessParam_FIRST                = 0,

    NvProcessParam_VRR_PERIOD           = 0,
    NvProcessParam_VSYNC_PERIOD,

    NvProcessParam_COUNT,
    NvProcessParam_LAST                 = NvProcessParam_COUNT-1,
    NvProcessParam_Force32              = 0x7FFFFFFF
} NvProcessParam;

typedef enum
{
    NvSystemParam_FIRST                 = 0,

    NvSystemParam_PHS_CYCLE             = 0, /* Last cycle finished. */
    NvSystemParam_CPU_IL,               /* Range [0.0, 1.0] as [0, UINT32_MAX] */
    NvSystemParam_GPU_IL,               /* Range [0.0, 1.0] as [0, UINT32_MAX] */
    NvSystemParam_CAPTURE_HINT_STATS,   /* When greater than zero, capture hint timestamps. */
    NvSystemParam_COUNT,
    NvSystemParam_LAST                  = NvSystemParam_COUNT-1,
    NvSystemParam_Force32               = 0x7FFFFFFF
} NvSystemParam;

int NvPHSSendThroughputHints (uint32_t client_tag, uint32_t flags, ...) {
    return 0;
}

void NvPHSCancelThroughputHints (uint32_t client_tag, NvUsecase usecase) {
    return;
}

int NvPHSSetThrottle (uint32_t client_tag, uint32_t interval_ms) {
    return 0;
}

int NvPHSIsChannelOpen (void) {
    return 0;
}

NvUsecase NvPHSMuteUsecases (NvUsecase usecases_mask) {
    return usecases_mask;
}

NvUsecase NvPHSUnmuteUsecases (NvUsecase usecases_mask) {
    return usecases_mask;
}

int NvPHSMuteHintType (NvHintType type) {
    return 0;
}

int NvPHSUnmuteHintType (NvHintType type) {
    return 0;
}

int NvPHSReadSystemParameter (NvSystemParam param, uint32_t *rv) {
    *rv = 0;
    return 0;
}

int NvPHSReadProcessParameter (NvProcessParam param, uint32_t *rv) {
    *rv = 0;
    return 0;
}
