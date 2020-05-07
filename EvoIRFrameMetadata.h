
#ifndef EVOIRFRAMEMETADATA_H_
#define EVOIRFRAMEMETADATA_H_

#include "irdirectsdk_defs.h"

#ifdef  __cplusplus
extern "C" {
#endif

typedef enum { irFlagOpen, irFlagClose, irFlagOpening, irFlagClosing, irFlagError } EvoIRFlagState;

typedef struct __IRDIRECTSDK_API__ EvoIRFrameMetadata
{
  unsigned int counter;     /*!< Consecutively numbered for each received frame */
  unsigned int counterHW;   /*!< Hardware counter received from device, multiply with value returned by IRImager::getAvgTimePerFrame() to get a hardware timestamp */
  long long timestamp;      /*!< Time stamp in UNITS (10000000 per second) */
  long long timestampMedia;
  EvoIRFlagState flagState; /*!< State of shutter flag at capturing time */
  float tempChip;           /*!< Chip temperature */
  float tempFlag;           /*!< Shutter flag temperature */
  float tempBox;            /*!< Temperature inside camera housing */
} EvoIRFrameMetadata;


#ifdef  __cplusplus
}
#endif

#endif /* EVOIRFRAMEMETADATA_H_ */