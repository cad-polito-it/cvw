#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint32_t *data_start;
uint32_t *data_end;

void write_payload (uint32_t payload, uint8_t dir) {
  uint32_t  *base;
  uint16_t i, it=0;

  if (dir) {
    for (base = data_start; base < data_end; base += 128) {
      for (i=0; i<128; i++) {
        *(base+i) = payload;
        printf("writing: %x at %x, value %x\n", payload, base+i, *(base+i));
      }
    }
  }
  else {
    for (base = data_end-128; base >= data_start; base -= 128) {
      for (i=128; i>=1; i--) {
        *(base+i-1) = payload;
        printf("writing: %x at %x, value %x \n", payload, base+i-1, *(base+i-1));
      }
    }
  }
}

uint32_t * check_payload (uint32_t golden_payload, uint8_t dir) {
  uint32_t tmp;
  uint32_t  *base;
  uint16_t i;

  if (dir) {
    for (base = data_start; base < data_end; base += 128) {
      printf("base address: %x\n", base);
      for (i=0; i<128; i++) {
        tmp = *(base+i);
        printf("address: %x, golden: %x actual: %x, i: %d\n", base+i, golden_payload, tmp, i);
        if (tmp!=golden_payload) return (base+i);
      }
    }
  }
  else {
    for (base = data_end-128; base >= data_start; base -= 128) {
      for (i=128; i>=1; i--) {
        tmp = *(base+i-1);
        printf("address: %x, golden: %x actual: %x, i: %d\n", base+i-1, golden_payload, tmp, i);
        if (tmp!=golden_payload) return (base+i-1);
      }
    }
  }
  return NULL;
}


int main()
{
  uint32_t payload=0;
  uint32_t  i, *ret = NULL;
  uint32_t patterns[5] = {0x55555555, 0x33333333,0x0F0F0F0F, 0x00FF00FF, 0x0000FFFF};
  
  data_start = (uint32_t *) malloc(sizeof(uint32_t) * 128);
  data_end = data_start+128;
  
  printf("data start: %x data end: %x\n", data_start, data_end);

  // step 0
  printf("step 0: write 0 descending\n");
  write_payload(payload, 1); // 1 descending, 0 ascending

  // // step 1
  // printf("step 1: read 0 ascending\n");
  // ret = check_payload(payload, 0);
  // if (ret) return -1;
  // payload=-1;
  // printf("step 1: write 1 ascending\n");
  // write_payload(payload, 0);
  
  // // step 2
  // printf("step 2: read 1 ascending\n");
  // ret = check_payload(payload, 0);
  // if (ret) return -1;
  // payload=0;
  // printf("step 2: write 0 ascending\n");
  // write_payload(payload, 0);

  // // step 3
  // printf("step 3: read 0 descending\n");
  // ret = check_payload(payload, 1);
  // if (ret) return -1;
  // payload=-1;
  // printf("step 3: write 1 descending\n");
  // write_payload(payload, 1);

  // // step 4
  // printf("step 4: read 1 descending\n");
  // ret = check_payload(payload, 1);
  // if (ret) return -1;
  // payload=0;
  // printf("step 4: write 0 descending\n");
  // write_payload(payload, 1);
  
  // for (i=0; i<5; i++) {
  //   printf("step %d: read patter descending\n", i+5);
  //   ret = check_payload(payload, 1);
  //   if (ret) return -1;
  //   payload=patterns[i];
  //   printf("step %d: write pattern descending\n", i+5);
  //   write_payload(payload, 1);

  //   printf("step %d: read pattern ascending\n", i+5);
  //   ret = check_payload(payload, 0);
  //   if (ret) return -1;
  //   payload=~payload;
  //   printf("step %d: write pattern ascending\n", i+5);
  //   write_payload(payload, 0);
  // }
  // printf("step %d: read patter descending\n", 10);
  // ret = check_payload(payload, 1);
  // if (ret) return -1;


  return 0;
}
