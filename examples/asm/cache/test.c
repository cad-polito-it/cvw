#include "tests.h"

/* https://onlinedocs.microchip.com/oxy/GUID-D1946615-13DB-429F-8835-9FD61AEECC58-en-US-1/GUID-58171B11-CBE8-45BA-9D76-C57C942F4352.html 
 * ⇕0(w00000000);
 * ⇑1(r00000000,w11111111);
 * ⇑2(r11111111,w00000000);
 * ⇓3(r00000000,w11111111);
 * ⇓4(r11111111,w00000000);
 * TODO: maybe flush
 * ⇓5(r00000000, w01010101);
 * ⇑6 (r01010101, w10101010);
 * ⇓7(r10101010, w01010101);
 * ⇑8(r01010101, w00110011);
 * ⇓9(r00110011, w11001100);
 * ⇑10(r11001100, w00110011);
 * ⇓11(r00110011, w00001111);
 * ⇑12(r00001111, w11110000);
 * ⇓13(r11110000, w00001111);
 * ⇑14(r00001111)}
*/

void write_payload (uint32_t payload, uint8_t dir) {
  uint32_t  *base;
  uint16_t i;
  
  if (dir) {
    for (base = __data_start; base < __data_end; base += 128) {
      for (i=0; i<128; i++) {
        *(base+i) = payload;
      }
    }
  }
  else {
    for (base = __data_end-128; base >= __data_start; base -= 128) {
      for (i=128; i>0; i--) {
        *(base+i) = payload;
      }
    }
  }
}

uint32_t * check_payload (uint32_t golden_payload, uint32_t dir) {
  uint32_t tmp;
  uint32_t  *base;
  uint16_t i;

  if (dir) {
    for (base = __data_start; base < __data_end; base += 128) {
      for (i=0; i<128; i++) {
        tmp = *(base+i);
	if (tmp!=golden_payload) return (base+i);
      }
    }
  }
  else {
    for (base = __data_end-128; base >= __data_start; base -= 128) {
      for (i=128; i>0; i--) {
	tmp = *(base+i);
	if (tmp!=golden_payload) return (base+i);
      }
    }
  }
}

void march_c_minus_one_way(void) {
  uint32_t payload=0;
  uint8_t  i;
  uint32_t *ret;
  uint32_t patterns[5] = {0x55555555, 0x33333333,0x0F0F0F0F, 0x00FF00FF, 0x0000FFFF};

  // step 0
  write_payload(payload, 1); // 1 descending, 0 ascending
  
  // step 1
  ret = check_payload(payload, 0);
  payload=-1;
  write_payload(payload, 0);

  // step 2
  ret = check_payload(payload, 0);
  payload=0;
  write_payload(payload, 0);

  // step 3
  ret = check_payload(payload, 1);
  payload=-1;
  write_payload(payload, 1);

  // step 4
  ret = check_payload(payload, 1);
  payload=0;
  write_payload(payload, 1);

  for (i=0; i<5; i++) {
    ret = check_payload(payload, 1);
    payload=patterns[i];
    write_payload(payload, 1);
    
    ret = check_payload(payload, 0);
    payload=~payload;
    if (i != 4) {
      write_payload(payload, 0);
    }
  }
  ret = check_payload(payload, 1);
}
