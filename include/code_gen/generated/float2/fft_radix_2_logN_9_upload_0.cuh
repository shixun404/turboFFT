
#include "../../../TurboFFT_radix_2_template.h"
template<>
__global__ void fft_radix_2<float2, 9, 0, 0, 0>(float2* inputs, float2* outputs, float2* twiddle, float2* checksum_DFT, int BS, int thread_bs) {
    int bid_cnt = 0;
    
    float2* shared = (float2*) ext_shared;
    int threadblock_per_SM = 32;
    int tb_gap = threadblock_per_SM * 108;
    int delta_bid = ((blockIdx.x / tb_gap) ==  (gridDim.x / tb_gap)) ? (gridDim.x % tb_gap) : tb_gap;
    float2 r[3];
    r[0].x = 1.0;
    r[0].y = 0.0;
    r[1].x = -0.5;
    r[1].y = -0.8660253882408142;
    r[2].x = -0.5;
    r[2].y = 0.8660253882408142;
    int j;
    int k;
    int global_j;
    int global_k;
    int data_id;
    int bs_id;
    int shared_offset_bs;
    int shared_offset_data;
    int bx;
    int tx;
    int offset;
    float2* gPtr;
    float2* shPtr;
    float2 rPtr[8];
    float2 rPtr_2[8];
    float2 rPtr_3[8];
    float2 rPtr_4[8];
    float2 tmp;
    float2 tmp_1;
    float2 tmp_2;
    float2 tmp_3;
    float2 angle;
    float2 delta_angle;
    j = 0;
    k = -1;
    global_j = 0;
    global_k = 0;
    data_id = 0;
    bs_id = 0;
    shared_offset_bs = 0;
    shared_offset_data = 0;
    bx = blockIdx.x;
    tx = threadIdx.x;
    offset = 0;
    gPtr = inputs;
    shPtr = shared;
    
    __syncthreads();
    int bid = 0;
    for(bid = (blockIdx.x / tb_gap) * tb_gap * thread_bs + blockIdx.x % tb_gap;
                bid_cnt < thread_bs && bid < (512 * BS + 512 - 1) / 512; bid += delta_bid)
    {
    bid_cnt += 1;
            
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
        rPtr[0] = *(gPtr + 0);
        rPtr_3[0].x += rPtr[0].x;
        rPtr_3[0].y += rPtr[0].y;
        
        rPtr[1] = *(gPtr + 64);
        rPtr_3[1].x += rPtr[1].x;
        rPtr_3[1].y += rPtr[1].y;
        
        rPtr[2] = *(gPtr + 128);
        rPtr_3[2].x += rPtr[2].x;
        rPtr_3[2].y += rPtr[2].y;
        
        rPtr[3] = *(gPtr + 192);
        rPtr_3[3].x += rPtr[3].x;
        rPtr_3[3].y += rPtr[3].y;
        
        rPtr[4] = *(gPtr + 256);
        rPtr_3[4].x += rPtr[4].x;
        rPtr_3[4].y += rPtr[4].y;
        
        rPtr[5] = *(gPtr + 320);
        rPtr_3[5].x += rPtr[5].x;
        rPtr_3[5].y += rPtr[5].y;
        
        rPtr[6] = *(gPtr + 384);
        rPtr_3[6].x += rPtr[6].x;
        rPtr_3[6].y += rPtr[6].y;
        
        rPtr[7] = *(gPtr + 448);
        rPtr_3[7].x += rPtr[7].x;
        rPtr_3[7].y += rPtr[7].y;
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    j = tx / 1;
    
    offset += ((tx / 1) % 8) * 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[511 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 1 * (0 + threadIdx.x % 8) % 8 + (0 / 8) * 8] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 1 * (1 + threadIdx.x % 8) % 8 + (1 / 8) * 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 1 * (2 + threadIdx.x % 8) % 8 + (2 / 8) * 8] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 1 * (3 + threadIdx.x % 8) % 8 + (3 / 8) * 8] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1 * (4 + threadIdx.x % 8) % 8 + (4 / 8) * 8] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1 * (5 + threadIdx.x % 8) % 8 + (5 / 8) * 8] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1 * (6 + threadIdx.x % 8) % 8 + (6 / 8) * 8] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1 * (7 + threadIdx.x % 8) % 8 + (7 / 8) * 8] = rPtr[7];
    
    offset = 0;
    offset += (tx / 8) * 8 + 
              ((tx % 8) / 8) * 8 + (tx % 8 + tx / 8) % 8;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 16] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 24] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 32] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 40] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 48] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 56] = rPtr[7];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
            *(gPtr + 0) = rPtr[0];
            rPtr_4[0].x += rPtr[0].x;
            rPtr_4[0].y += rPtr[0].y;
            
            *(gPtr + 64) = rPtr[4];
            rPtr_4[1].x += rPtr[4].x;
            rPtr_4[1].y += rPtr[4].y;
            
            *(gPtr + 128) = rPtr[2];
            rPtr_4[2].x += rPtr[2].x;
            rPtr_4[2].y += rPtr[2].y;
            
            *(gPtr + 192) = rPtr[6];
            rPtr_4[3].x += rPtr[6].x;
            rPtr_4[3].y += rPtr[6].y;
            
            *(gPtr + 256) = rPtr[1];
            rPtr_4[4].x += rPtr[1].x;
            rPtr_4[4].y += rPtr[1].y;
            
            *(gPtr + 320) = rPtr[5];
            rPtr_4[5].x += rPtr[5].x;
            rPtr_4[5].y += rPtr[5].y;
            
            *(gPtr + 384) = rPtr[3];
            rPtr_4[6].x += rPtr[3].x;
            rPtr_4[6].y += rPtr[3].y;
            
            *(gPtr + 448) = rPtr[7];
            rPtr_4[7].x += rPtr[7].x;
            rPtr_4[7].y += rPtr[7].y;
            
    }
    
}

#include "../../../TurboFFT_radix_2_template.h"
template<>
__global__ void fft_radix_2<float2, 9, 0, 1, 0>(float2* inputs, float2* outputs, float2* twiddle, float2* checksum_DFT, int BS, int thread_bs) {
    int bid_cnt = 0;
    
    float2* shared = (float2*) ext_shared;
    int threadblock_per_SM = 32;
    int tb_gap = threadblock_per_SM * 108;
    int delta_bid = ((blockIdx.x / tb_gap) ==  (gridDim.x / tb_gap)) ? (gridDim.x % tb_gap) : tb_gap;
    float2 r[3];
    r[0].x = 1.0;
    r[0].y = 0.0;
    r[1].x = -0.5;
    r[1].y = -0.8660253882408142;
    r[2].x = -0.5;
    r[2].y = 0.8660253882408142;
    int j;
    int k;
    int global_j;
    int global_k;
    int data_id;
    int bs_id;
    int shared_offset_bs;
    int shared_offset_data;
    int bx;
    int tx;
    int offset;
    float2* gPtr;
    float2* shPtr;
    float2 rPtr[8];
    float2 rPtr_2[8];
    float2 rPtr_3[8];
    float2 rPtr_4[8];
    float2 tmp;
    float2 tmp_1;
    float2 tmp_2;
    float2 tmp_3;
    float2 angle;
    float2 delta_angle;
    j = 0;
    k = -1;
    global_j = 0;
    global_k = 0;
    data_id = 0;
    bs_id = 0;
    shared_offset_bs = 0;
    shared_offset_data = 0;
    bx = blockIdx.x;
    tx = threadIdx.x;
    offset = 0;
    gPtr = inputs;
    shPtr = shared;
    
    rPtr_2[0] = *(checksum_DFT + 512 - 2 + tx + 0);
    shPtr[tx + 0] = rPtr_2[0];
    
    rPtr_2[1] = *(checksum_DFT + 512 - 2 + tx + 64);
    shPtr[tx + 64] = rPtr_2[1];
    
    rPtr_2[2] = *(checksum_DFT + 512 - 2 + tx + 128);
    shPtr[tx + 128] = rPtr_2[2];
    
    rPtr_2[3] = *(checksum_DFT + 512 - 2 + tx + 192);
    shPtr[tx + 192] = rPtr_2[3];
    
    rPtr_2[4] = *(checksum_DFT + 512 - 2 + tx + 256);
    shPtr[tx + 256] = rPtr_2[4];
    
    rPtr_2[5] = *(checksum_DFT + 512 - 2 + tx + 320);
    shPtr[tx + 320] = rPtr_2[5];
    
    rPtr_2[6] = *(checksum_DFT + 512 - 2 + tx + 384);
    shPtr[tx + 384] = rPtr_2[6];
    
    rPtr_2[7] = *(checksum_DFT + 512 - 2 + tx + 448);
    shPtr[tx + 448] = rPtr_2[7];
    
    __syncthreads();
    tmp_1.x = 0;
    tmp_1.y = 0;
    tmp_2.x = 0;
    tmp_2.y = 0;
    tmp_3.x = 0;
    tmp_3.y = 0;
    
    rPtr_2[0] = *(shPtr +  tx / 1 + 0);
    rPtr_3[0].x = 0; rPtr_3[0].y = 0;
    rPtr_4[0].x = 0; rPtr_4[0].y = 0;
    
    rPtr_2[1] = *(shPtr +  tx / 1 + 64);
    rPtr_3[1].x = 0; rPtr_3[1].y = 0;
    rPtr_4[1].x = 0; rPtr_4[1].y = 0;
    
    rPtr_2[2] = *(shPtr +  tx / 1 + 128);
    rPtr_3[2].x = 0; rPtr_3[2].y = 0;
    rPtr_4[2].x = 0; rPtr_4[2].y = 0;
    
    rPtr_2[3] = *(shPtr +  tx / 1 + 192);
    rPtr_3[3].x = 0; rPtr_3[3].y = 0;
    rPtr_4[3].x = 0; rPtr_4[3].y = 0;
    
    rPtr_2[4] = *(shPtr +  tx / 1 + 256);
    rPtr_3[4].x = 0; rPtr_3[4].y = 0;
    rPtr_4[4].x = 0; rPtr_4[4].y = 0;
    
    rPtr_2[5] = *(shPtr +  tx / 1 + 320);
    rPtr_3[5].x = 0; rPtr_3[5].y = 0;
    rPtr_4[5].x = 0; rPtr_4[5].y = 0;
    
    rPtr_2[6] = *(shPtr +  tx / 1 + 384);
    rPtr_3[6].x = 0; rPtr_3[6].y = 0;
    rPtr_4[6].x = 0; rPtr_4[6].y = 0;
    
    rPtr_2[7] = *(shPtr +  tx / 1 + 448);
    rPtr_3[7].x = 0; rPtr_3[7].y = 0;
    rPtr_4[7].x = 0; rPtr_4[7].y = 0;
    
    __syncthreads();
    int bid = 0;
    for(bid = (blockIdx.x / tb_gap) * tb_gap * thread_bs + blockIdx.x % tb_gap;
                bid_cnt < thread_bs && bid < (512 * BS + 512 - 1) / 512; bid += delta_bid)
    {
    bid_cnt += 1;
            
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
        rPtr[0] = *(gPtr + 0);
        rPtr_3[0].x += rPtr[0].x;
        rPtr_3[0].y += rPtr[0].y;
        
        // tmp = checksum_DFT[tx / 1 + 0];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[0], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[0], rPtr_2[0])
        turboFFT_ZMUL(tmp, rPtr[0], rPtr_2[0])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[1] = *(gPtr + 64);
        rPtr_3[1].x += rPtr[1].x;
        rPtr_3[1].y += rPtr[1].y;
        
        // tmp = checksum_DFT[tx / 1 + 64];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[1], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[1], rPtr_2[1])
        turboFFT_ZMUL(tmp, rPtr[1], rPtr_2[1])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[2] = *(gPtr + 128);
        rPtr_3[2].x += rPtr[2].x;
        rPtr_3[2].y += rPtr[2].y;
        
        // tmp = checksum_DFT[tx / 1 + 128];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[2], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[2], rPtr_2[2])
        turboFFT_ZMUL(tmp, rPtr[2], rPtr_2[2])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[3] = *(gPtr + 192);
        rPtr_3[3].x += rPtr[3].x;
        rPtr_3[3].y += rPtr[3].y;
        
        // tmp = checksum_DFT[tx / 1 + 192];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[3], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[3], rPtr_2[3])
        turboFFT_ZMUL(tmp, rPtr[3], rPtr_2[3])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[4] = *(gPtr + 256);
        rPtr_3[4].x += rPtr[4].x;
        rPtr_3[4].y += rPtr[4].y;
        
        // tmp = checksum_DFT[tx / 1 + 256];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[4], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[4], rPtr_2[4])
        turboFFT_ZMUL(tmp, rPtr[4], rPtr_2[4])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[5] = *(gPtr + 320);
        rPtr_3[5].x += rPtr[5].x;
        rPtr_3[5].y += rPtr[5].y;
        
        // tmp = checksum_DFT[tx / 1 + 320];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[5], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[5], rPtr_2[5])
        turboFFT_ZMUL(tmp, rPtr[5], rPtr_2[5])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[6] = *(gPtr + 384);
        rPtr_3[6].x += rPtr[6].x;
        rPtr_3[6].y += rPtr[6].y;
        
        // tmp = checksum_DFT[tx / 1 + 384];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[6], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[6], rPtr_2[6])
        turboFFT_ZMUL(tmp, rPtr[6], rPtr_2[6])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[7] = *(gPtr + 448);
        rPtr_3[7].x += rPtr[7].x;
        rPtr_3[7].y += rPtr[7].y;
        
        // tmp = checksum_DFT[tx / 1 + 448];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[7], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[7], rPtr_2[7])
        turboFFT_ZMUL(tmp, rPtr[7], rPtr_2[7])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        // tmp_3.x += bid_cnt * (rPtr[0].x + rPtr[0].y) * 512;
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    j = tx / 1;
    
    offset += ((tx / 1) % 8) * 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[511 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 1 * (0 + threadIdx.x % 8) % 8 + (0 / 8) * 8] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 1 * (1 + threadIdx.x % 8) % 8 + (1 / 8) * 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 1 * (2 + threadIdx.x % 8) % 8 + (2 / 8) * 8] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 1 * (3 + threadIdx.x % 8) % 8 + (3 / 8) * 8] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1 * (4 + threadIdx.x % 8) % 8 + (4 / 8) * 8] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1 * (5 + threadIdx.x % 8) % 8 + (5 / 8) * 8] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1 * (6 + threadIdx.x % 8) % 8 + (6 / 8) * 8] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1 * (7 + threadIdx.x % 8) % 8 + (7 / 8) * 8] = rPtr[7];
    
    offset = 0;
    offset += (tx / 8) * 8 + 
              ((tx % 8) / 8) * 8 + (tx % 8 + tx / 8) % 8;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 16] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 24] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 32] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 40] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 48] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 56] = rPtr[7];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
        // 1's vector
        // tmp_3.y -=  (rPtr[0].y + rPtr[0].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[0].y + rPtr[0].x);
        turboFFT_ZMUL(tmp, rPtr[0],r[(0 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[0], r[(0 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[0], r[(0 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[4].y + rPtr[4].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[4].y + rPtr[4].x);
        turboFFT_ZMUL(tmp, rPtr[4],r[(64 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[4], r[(64 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[4], r[(64 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[2].y + rPtr[2].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[2].y + rPtr[2].x);
        turboFFT_ZMUL(tmp, rPtr[2],r[(128 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[2], r[(128 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[2], r[(128 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[6].y + rPtr[6].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[6].y + rPtr[6].x);
        turboFFT_ZMUL(tmp, rPtr[6],r[(192 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[6], r[(192 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[6], r[(192 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[1].y + rPtr[1].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[1].y + rPtr[1].x);
        turboFFT_ZMUL(tmp, rPtr[1],r[(256 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[1], r[(256 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[1], r[(256 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[5].y + rPtr[5].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[5].y + rPtr[5].x);
        turboFFT_ZMUL(tmp, rPtr[5],r[(320 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[5], r[(320 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[5], r[(320 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[3].y + rPtr[3].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[3].y + rPtr[3].x);
        turboFFT_ZMUL(tmp, rPtr[3],r[(384 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[3], r[(384 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[3], r[(384 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[7].y + rPtr[7].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[7].y + rPtr[7].x);
        turboFFT_ZMUL(tmp, rPtr[7],r[(448 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[7], r[(448 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[7], r[(448 + tx / 1) % 3])
        
            *(gPtr + 0) = rPtr[0];
            rPtr_4[0].x += rPtr[0].x;
            rPtr_4[0].y += rPtr[0].y;
            
            *(gPtr + 64) = rPtr[4];
            rPtr_4[1].x += rPtr[4].x;
            rPtr_4[1].y += rPtr[4].y;
            
            *(gPtr + 128) = rPtr[2];
            rPtr_4[2].x += rPtr[2].x;
            rPtr_4[2].y += rPtr[2].y;
            
            *(gPtr + 192) = rPtr[6];
            rPtr_4[3].x += rPtr[6].x;
            rPtr_4[3].y += rPtr[6].y;
            
            *(gPtr + 256) = rPtr[1];
            rPtr_4[4].x += rPtr[1].x;
            rPtr_4[4].y += rPtr[1].y;
            
            *(gPtr + 320) = rPtr[5];
            rPtr_4[5].x += rPtr[5].x;
            rPtr_4[5].y += rPtr[5].y;
            
            *(gPtr + 384) = rPtr[3];
            rPtr_4[6].x += rPtr[3].x;
            rPtr_4[6].y += rPtr[3].y;
            
            *(gPtr + 448) = rPtr[7];
            rPtr_4[7].x += rPtr[7].x;
            rPtr_4[7].y += rPtr[7].y;
            
        if(bid_cnt==thread_bs)
        
        {
        
        // 1's vector
        // tmp.x = (tx / 1 == 0) ? (rPtr_3[0].y + rPtr_3[0].x) * 512: 0;
        // tmp.y = (tx / 1 == 0) ? (abs(rPtr_3[0].y) + abs(rPtr_3[0].x)) * 512: 0;
        tmp = tmp_1;
        tmp_1.y += tmp.x;
        tmp_1.x = (abs(tmp.y) + abs(tmp.x));
        
        // 1's vector
        // tmp.x = (tx / 1 == 0) ? tmp_3.x : 0;
        tmp.x = tmp_3.x;
        tmp_3.y = tmp.x + tmp_3.y;
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 16, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 8, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 4, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 2, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 1, 32);
        
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 16, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 8, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 4, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 2, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 1, 32);

         // ToDo: can be optimized __shfl_sync
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 16, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 8, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 4, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 2, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 1, 32);
        __syncthreads();
        shPtr[(tx / 32) * 2] = tmp_1;
        shPtr[(tx / 32) * 2 + 1] = tmp_3;
        __syncthreads();
        
            tmp_1 = shPtr[(tx % 2) * 2];
            tmp_3 = shPtr[(tx % 2) * 2 + 1];
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 1, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 1, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 1, 32);
        
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(tx == 0)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if((blockIdx.x % thread_bs + 1) != round(abs(tmp_3.y) / abs(tmp_1.y)) && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 )  printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            //                                         bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x, tmp_3.y, tmp_3.y / tmp_1.y);
            // if(abs(tmp_1.y / tmp_1.x) > 0.001)printf("0, bid=%d bx=%d, by=%d, tx=%d: %f, %f, %f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // k = abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 ? bid : k;
            k = abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 ? round(abs(tmp_3.y) / abs(tmp_1.y)) : k;
            // k = abs(tmp_1.y) > 10 ? bid : k;
            // if(tx == 0) *(gPtr) = tmp_1;
            // if(tx == 0 && abs(tmp_1.y / tmp_1.x) > 1e-3)
            
            }
            // }            
            
    }
    
}

#include "../../../TurboFFT_radix_2_template.h"
template<>
__global__ void fft_radix_2<float2, 9, 0, 1, 1>(float2* inputs, float2* outputs, float2* twiddle, float2* checksum_DFT, int BS, int thread_bs) {
    int bid_cnt = 0;
    
    float2* shared = (float2*) ext_shared;
    int threadblock_per_SM = 32;
    int tb_gap = threadblock_per_SM * 108;
    int delta_bid = ((blockIdx.x / tb_gap) ==  (gridDim.x / tb_gap)) ? (gridDim.x % tb_gap) : tb_gap;
    float2 r[3];
    r[0].x = 1.0;
    r[0].y = 0.0;
    r[1].x = -0.5;
    r[1].y = -0.8660253882408142;
    r[2].x = -0.5;
    r[2].y = 0.8660253882408142;
    int j;
    int k;
    int global_j;
    int global_k;
    int data_id;
    int bs_id;
    int shared_offset_bs;
    int shared_offset_data;
    int bx;
    int tx;
    int offset;
    float2* gPtr;
    float2* shPtr;
    float2 rPtr[8];
    float2 rPtr_2[8];
    float2 rPtr_3[8];
    float2 rPtr_4[8];
    float2 tmp;
    float2 tmp_1;
    float2 tmp_2;
    float2 tmp_3;
    float2 angle;
    float2 delta_angle;
    j = 0;
    k = -1;
    global_j = 0;
    global_k = 0;
    data_id = 0;
    bs_id = 0;
    shared_offset_bs = 0;
    shared_offset_data = 0;
    bx = blockIdx.x;
    tx = threadIdx.x;
    offset = 0;
    gPtr = inputs;
    shPtr = shared;
    
    rPtr_2[0] = *(checksum_DFT + 512 - 2 + tx + 0);
    shPtr[tx + 0] = rPtr_2[0];
    
    rPtr_2[1] = *(checksum_DFT + 512 - 2 + tx + 64);
    shPtr[tx + 64] = rPtr_2[1];
    
    rPtr_2[2] = *(checksum_DFT + 512 - 2 + tx + 128);
    shPtr[tx + 128] = rPtr_2[2];
    
    rPtr_2[3] = *(checksum_DFT + 512 - 2 + tx + 192);
    shPtr[tx + 192] = rPtr_2[3];
    
    rPtr_2[4] = *(checksum_DFT + 512 - 2 + tx + 256);
    shPtr[tx + 256] = rPtr_2[4];
    
    rPtr_2[5] = *(checksum_DFT + 512 - 2 + tx + 320);
    shPtr[tx + 320] = rPtr_2[5];
    
    rPtr_2[6] = *(checksum_DFT + 512 - 2 + tx + 384);
    shPtr[tx + 384] = rPtr_2[6];
    
    rPtr_2[7] = *(checksum_DFT + 512 - 2 + tx + 448);
    shPtr[tx + 448] = rPtr_2[7];
    
    __syncthreads();
    tmp_1.x = 0;
    tmp_1.y = 0;
    tmp_2.x = 0;
    tmp_2.y = 0;
    tmp_3.x = 0;
    tmp_3.y = 0;
    
    rPtr_2[0] = *(shPtr +  tx / 1 + 0);
    rPtr_3[0].x = 0; rPtr_3[0].y = 0;
    rPtr_4[0].x = 0; rPtr_4[0].y = 0;
    
    rPtr_2[1] = *(shPtr +  tx / 1 + 64);
    rPtr_3[1].x = 0; rPtr_3[1].y = 0;
    rPtr_4[1].x = 0; rPtr_4[1].y = 0;
    
    rPtr_2[2] = *(shPtr +  tx / 1 + 128);
    rPtr_3[2].x = 0; rPtr_3[2].y = 0;
    rPtr_4[2].x = 0; rPtr_4[2].y = 0;
    
    rPtr_2[3] = *(shPtr +  tx / 1 + 192);
    rPtr_3[3].x = 0; rPtr_3[3].y = 0;
    rPtr_4[3].x = 0; rPtr_4[3].y = 0;
    
    rPtr_2[4] = *(shPtr +  tx / 1 + 256);
    rPtr_3[4].x = 0; rPtr_3[4].y = 0;
    rPtr_4[4].x = 0; rPtr_4[4].y = 0;
    
    rPtr_2[5] = *(shPtr +  tx / 1 + 320);
    rPtr_3[5].x = 0; rPtr_3[5].y = 0;
    rPtr_4[5].x = 0; rPtr_4[5].y = 0;
    
    rPtr_2[6] = *(shPtr +  tx / 1 + 384);
    rPtr_3[6].x = 0; rPtr_3[6].y = 0;
    rPtr_4[6].x = 0; rPtr_4[6].y = 0;
    
    rPtr_2[7] = *(shPtr +  tx / 1 + 448);
    rPtr_3[7].x = 0; rPtr_3[7].y = 0;
    rPtr_4[7].x = 0; rPtr_4[7].y = 0;
    
    __syncthreads();
    int bid = 0;
    for(bid = (blockIdx.x / tb_gap) * tb_gap * thread_bs + blockIdx.x % tb_gap;
                bid_cnt < thread_bs && bid < (512 * BS + 512 - 1) / 512; bid += delta_bid)
    {
    bid_cnt += 1;
            
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
        rPtr[0] = *(gPtr + 0);
        rPtr_3[0].x += rPtr[0].x;
        rPtr_3[0].y += rPtr[0].y;
        
        // tmp = checksum_DFT[tx / 1 + 0];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[0], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[0], rPtr_2[0])
        turboFFT_ZMUL(tmp, rPtr[0], rPtr_2[0])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[1] = *(gPtr + 64);
        rPtr_3[1].x += rPtr[1].x;
        rPtr_3[1].y += rPtr[1].y;
        
        // tmp = checksum_DFT[tx / 1 + 64];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[1], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[1], rPtr_2[1])
        turboFFT_ZMUL(tmp, rPtr[1], rPtr_2[1])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[2] = *(gPtr + 128);
        rPtr_3[2].x += rPtr[2].x;
        rPtr_3[2].y += rPtr[2].y;
        
        // tmp = checksum_DFT[tx / 1 + 128];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[2], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[2], rPtr_2[2])
        turboFFT_ZMUL(tmp, rPtr[2], rPtr_2[2])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[3] = *(gPtr + 192);
        rPtr_3[3].x += rPtr[3].x;
        rPtr_3[3].y += rPtr[3].y;
        
        // tmp = checksum_DFT[tx / 1 + 192];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[3], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[3], rPtr_2[3])
        turboFFT_ZMUL(tmp, rPtr[3], rPtr_2[3])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[4] = *(gPtr + 256);
        rPtr_3[4].x += rPtr[4].x;
        rPtr_3[4].y += rPtr[4].y;
        
        // tmp = checksum_DFT[tx / 1 + 256];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[4], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[4], rPtr_2[4])
        turboFFT_ZMUL(tmp, rPtr[4], rPtr_2[4])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[5] = *(gPtr + 320);
        rPtr_3[5].x += rPtr[5].x;
        rPtr_3[5].y += rPtr[5].y;
        
        // tmp = checksum_DFT[tx / 1 + 320];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[5], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[5], rPtr_2[5])
        turboFFT_ZMUL(tmp, rPtr[5], rPtr_2[5])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[6] = *(gPtr + 384);
        rPtr_3[6].x += rPtr[6].x;
        rPtr_3[6].y += rPtr[6].y;
        
        // tmp = checksum_DFT[tx / 1 + 384];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[6], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[6], rPtr_2[6])
        turboFFT_ZMUL(tmp, rPtr[6], rPtr_2[6])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[7] = *(gPtr + 448);
        rPtr_3[7].x += rPtr[7].x;
        rPtr_3[7].y += rPtr[7].y;
        
        // tmp = checksum_DFT[tx / 1 + 448];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[7], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[7], rPtr_2[7])
        turboFFT_ZMUL(tmp, rPtr[7], rPtr_2[7])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        // tmp_3.x += bid_cnt * (rPtr[0].x + rPtr[0].y) * 512;
        
        rPtr[0].x += (threadIdx.x == 0 && bid_cnt == (blockIdx.x % thread_bs + 1)) ? 100: 0;
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    j = tx / 1;
    
    offset += ((tx / 1) % 8) * 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[511 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 1 * (0 + threadIdx.x % 8) % 8 + (0 / 8) * 8] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 1 * (1 + threadIdx.x % 8) % 8 + (1 / 8) * 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 1 * (2 + threadIdx.x % 8) % 8 + (2 / 8) * 8] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 1 * (3 + threadIdx.x % 8) % 8 + (3 / 8) * 8] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1 * (4 + threadIdx.x % 8) % 8 + (4 / 8) * 8] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1 * (5 + threadIdx.x % 8) % 8 + (5 / 8) * 8] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1 * (6 + threadIdx.x % 8) % 8 + (6 / 8) * 8] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1 * (7 + threadIdx.x % 8) % 8 + (7 / 8) * 8] = rPtr[7];
    
    offset = 0;
    offset += (tx / 8) * 8 + 
              ((tx % 8) / 8) * 8 + (tx % 8 + tx / 8) % 8;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 16] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 24] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 32] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 40] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 48] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 56] = rPtr[7];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
        // 1's vector
        // tmp_3.y -=  (rPtr[0].y + rPtr[0].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[0].y + rPtr[0].x);
        turboFFT_ZMUL(tmp, rPtr[0],r[(0 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[0], r[(0 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[0], r[(0 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[4].y + rPtr[4].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[4].y + rPtr[4].x);
        turboFFT_ZMUL(tmp, rPtr[4],r[(64 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[4], r[(64 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[4], r[(64 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[2].y + rPtr[2].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[2].y + rPtr[2].x);
        turboFFT_ZMUL(tmp, rPtr[2],r[(128 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[2], r[(128 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[2], r[(128 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[6].y + rPtr[6].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[6].y + rPtr[6].x);
        turboFFT_ZMUL(tmp, rPtr[6],r[(192 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[6], r[(192 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[6], r[(192 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[1].y + rPtr[1].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[1].y + rPtr[1].x);
        turboFFT_ZMUL(tmp, rPtr[1],r[(256 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[1], r[(256 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[1], r[(256 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[5].y + rPtr[5].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[5].y + rPtr[5].x);
        turboFFT_ZMUL(tmp, rPtr[5],r[(320 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[5], r[(320 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[5], r[(320 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[3].y + rPtr[3].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[3].y + rPtr[3].x);
        turboFFT_ZMUL(tmp, rPtr[3],r[(384 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[3], r[(384 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[3], r[(384 + tx / 1) % 3])
        
        // 1's vector
        // tmp_3.y -=  (rPtr[7].y + rPtr[7].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[7].y + rPtr[7].x);
        turboFFT_ZMUL(tmp, rPtr[7],r[(448 + tx / 1) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[7], r[(448 + tx / 1) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[7], r[(448 + tx / 1) % 3])
        
            *(gPtr + 0) = rPtr[0];
            rPtr_4[0].x += rPtr[0].x;
            rPtr_4[0].y += rPtr[0].y;
            
            *(gPtr + 64) = rPtr[4];
            rPtr_4[1].x += rPtr[4].x;
            rPtr_4[1].y += rPtr[4].y;
            
            *(gPtr + 128) = rPtr[2];
            rPtr_4[2].x += rPtr[2].x;
            rPtr_4[2].y += rPtr[2].y;
            
            *(gPtr + 192) = rPtr[6];
            rPtr_4[3].x += rPtr[6].x;
            rPtr_4[3].y += rPtr[6].y;
            
            *(gPtr + 256) = rPtr[1];
            rPtr_4[4].x += rPtr[1].x;
            rPtr_4[4].y += rPtr[1].y;
            
            *(gPtr + 320) = rPtr[5];
            rPtr_4[5].x += rPtr[5].x;
            rPtr_4[5].y += rPtr[5].y;
            
            *(gPtr + 384) = rPtr[3];
            rPtr_4[6].x += rPtr[3].x;
            rPtr_4[6].y += rPtr[3].y;
            
            *(gPtr + 448) = rPtr[7];
            rPtr_4[7].x += rPtr[7].x;
            rPtr_4[7].y += rPtr[7].y;
            
        if(bid_cnt==thread_bs)
        
        {
        
        // 1's vector
        // tmp.x = (tx / 1 == 0) ? (rPtr_3[0].y + rPtr_3[0].x) * 512: 0;
        // tmp.y = (tx / 1 == 0) ? (abs(rPtr_3[0].y) + abs(rPtr_3[0].x)) * 512: 0;
        tmp = tmp_1;
        tmp_1.y += tmp.x;
        tmp_1.x = (abs(tmp.y) + abs(tmp.x));
        
        // 1's vector
        // tmp.x = (tx / 1 == 0) ? tmp_3.x : 0;
        tmp.x = tmp_3.x;
        tmp_3.y = tmp.x + tmp_3.y;
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 16, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 8, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 4, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 2, 32);
        tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 1, 32);
        
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 16, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 8, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 4, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 2, 32);
        tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 1, 32);

         // ToDo: can be optimized __shfl_sync
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 16, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 8, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 4, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 2, 32);
         tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 1, 32);
        __syncthreads();
        shPtr[(tx / 32) * 2] = tmp_1;
        shPtr[(tx / 32) * 2 + 1] = tmp_3;
        __syncthreads();
        
            tmp_1 = shPtr[(tx % 2) * 2];
            tmp_3 = shPtr[(tx % 2) * 2 + 1];
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 1, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 1, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 1, 32);
        
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(tx == 0)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if((blockIdx.x % thread_bs + 1) != round(abs(tmp_3.y) / abs(tmp_1.y)) && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 )  printf("0, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            //                                         bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x, tmp_3.y, tmp_3.y / tmp_1.y);
            // if(abs(tmp_1.y / tmp_1.x) > 0.001)printf("0, bid=%d bx=%d, by=%d, tx=%d: %f, %f, %f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // k = abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 ? bid : k;
            k = abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 ? round(abs(tmp_3.y) / abs(tmp_1.y)) : k;
            // k = abs(tmp_1.y) > 10 ? bid : k;
            // if(tx == 0) *(gPtr) = tmp_1;
            // if(tx == 0 && abs(tmp_1.y / tmp_1.x) > 1e-3)
            
            }
            // }            
            
                }
                if(k != -1){
                
                bid = (blockIdx.x / tb_gap) * tb_gap * thread_bs + blockIdx.x % tb_gap + delta_bid * (k - 1);
                // if(threadIdx.x == 0)printf("bid=%d, upload=%d, bx=%d, tx=%d, k = %d\n", bid, 0, blockIdx.x, threadIdx.x, k);
                // bid = k;
                        
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
        // rPtr[0] = rPtr_3[0];
        rPtr[0] = *(gPtr + 0);
        
        // rPtr[1] = rPtr_3[1];
        rPtr[1] = *(gPtr + 64);
        
        // rPtr[2] = rPtr_3[2];
        rPtr[2] = *(gPtr + 128);
        
        // rPtr[3] = rPtr_3[3];
        rPtr[3] = *(gPtr + 192);
        
        // rPtr[4] = rPtr_3[4];
        rPtr[4] = *(gPtr + 256);
        
        // rPtr[5] = rPtr_3[5];
        rPtr[5] = *(gPtr + 320);
        
        // rPtr[6] = rPtr_3[6];
        rPtr[6] = *(gPtr + 384);
        
        // rPtr[7] = rPtr_3[7];
        rPtr[7] = *(gPtr + 448);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    j = tx / 1;
    
    offset += ((tx / 1) % 8) * 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[511 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 1 * (0 + threadIdx.x % 8) % 8 + (0 / 8) * 8] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 1 * (1 + threadIdx.x % 8) % 8 + (1 / 8) * 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 1 * (2 + threadIdx.x % 8) % 8 + (2 / 8) * 8] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 1 * (3 + threadIdx.x % 8) % 8 + (3 / 8) * 8] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1 * (4 + threadIdx.x % 8) % 8 + (4 / 8) * 8] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1 * (5 + threadIdx.x % 8) % 8 + (5 / 8) * 8] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1 * (6 + threadIdx.x % 8) % 8 + (6 / 8) * 8] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1 * (7 + threadIdx.x % 8) % 8 + (7 / 8) * 8] = rPtr[7];
    
    offset = 0;
    offset += (tx / 8) * 8 + 
              ((tx % 8) / 8) * 8 + (tx % 8 + tx / 8) % 8;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 1) * 1;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 8) * 64;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 8] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 16] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 24] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 32] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 40] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 48] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 56] = rPtr[7];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 64];
    
    rPtr[2] = shPtr[offset + 128];
    
    rPtr[3] = shPtr[offset + 192];
    
    rPtr[4] = shPtr[offset + 256];
    
    rPtr[5] = shPtr[offset + 320];
    
    rPtr[6] = shPtr[offset + 384];
    
    rPtr[7] = shPtr[offset + 448];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476f;
        angle.y = -0.7071067811865475f;
        turboFFT_ZMUL(rPtr[5], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    rPtr[6].y = -tmp.x;
    rPtr[6].x = tmp.y;
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
        angle.x = -0.7071067811865475f;
        angle.y = -0.7071067811865476f;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[2]);
    turboFFT_ZSUB(rPtr[2], tmp, rPtr[2]);
    tmp = rPtr[2];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    rPtr[3].y = -tmp.x;
    rPtr[3].x = tmp.y;
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    rPtr[7].y = -tmp.x;
    rPtr[7].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[1]);
    turboFFT_ZSUB(rPtr[1], tmp, rPtr[1]);
    tmp = rPtr[1];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[3]);
    turboFFT_ZSUB(rPtr[3], tmp, rPtr[3]);
    tmp = rPtr[3];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    
    gPtr += tx / 1 * 1;
    
    gPtr += (bx % 1) * 512 * 1;
    bx = bx / 1;
    
    gPtr += (bx % BS * 512);
    
            // turboFFT_ZSUB(rPtr[0], rPtr[0], rPtr_4[0]);
            
            // turboFFT_ZSUB(rPtr[4], rPtr[4], rPtr_4[1]);
            
            // turboFFT_ZSUB(rPtr[2], rPtr[2], rPtr_4[2]);
            
            // turboFFT_ZSUB(rPtr[6], rPtr[6], rPtr_4[3]);
            
            // turboFFT_ZSUB(rPtr[1], rPtr[1], rPtr_4[4]);
            
            // turboFFT_ZSUB(rPtr[5], rPtr[5], rPtr_4[5]);
            
            // turboFFT_ZSUB(rPtr[3], rPtr[3], rPtr_4[6]);
            
            // turboFFT_ZSUB(rPtr[7], rPtr[7], rPtr_4[7]);
            
            // rPtr_3[0] = *(gPtr + 0);
            // turboFFT_ZADD(rPtr_3[0], rPtr_3[0], rPtr[0] );
            // *(gPtr + 0) = rPtr_3[0];
            *(gPtr + 0) = rPtr[0];
        
            // rPtr_3[1] = *(gPtr + 64);
            // turboFFT_ZADD(rPtr_3[1], rPtr_3[1], rPtr[4] );
            // *(gPtr + 64) = rPtr_3[1];
            *(gPtr + 64) = rPtr[4];
        
            // rPtr_3[2] = *(gPtr + 128);
            // turboFFT_ZADD(rPtr_3[2], rPtr_3[2], rPtr[2] );
            // *(gPtr + 128) = rPtr_3[2];
            *(gPtr + 128) = rPtr[2];
        
            // rPtr_3[3] = *(gPtr + 192);
            // turboFFT_ZADD(rPtr_3[3], rPtr_3[3], rPtr[6] );
            // *(gPtr + 192) = rPtr_3[3];
            *(gPtr + 192) = rPtr[6];
        
            // rPtr_3[4] = *(gPtr + 256);
            // turboFFT_ZADD(rPtr_3[4], rPtr_3[4], rPtr[1] );
            // *(gPtr + 256) = rPtr_3[4];
            *(gPtr + 256) = rPtr[1];
        
            // rPtr_3[5] = *(gPtr + 320);
            // turboFFT_ZADD(rPtr_3[5], rPtr_3[5], rPtr[5] );
            // *(gPtr + 320) = rPtr_3[5];
            *(gPtr + 320) = rPtr[5];
        
            // rPtr_3[6] = *(gPtr + 384);
            // turboFFT_ZADD(rPtr_3[6], rPtr_3[6], rPtr[3] );
            // *(gPtr + 384) = rPtr_3[6];
            *(gPtr + 384) = rPtr[3];
        
            // rPtr_3[7] = *(gPtr + 448);
            // turboFFT_ZADD(rPtr_3[7], rPtr_3[7], rPtr[7] );
            // *(gPtr + 448) = rPtr_3[7];
            *(gPtr + 448) = rPtr[7];
        }}