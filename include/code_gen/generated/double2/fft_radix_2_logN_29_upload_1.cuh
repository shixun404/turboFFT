
#include "../../../TurboFFT_radix_2_template.h"
template<>
__global__ void fft_radix_2<double2, 29, 1, 0, 0>(double2* inputs, double2* outputs, double2* twiddle, double2* checksum_DFT, int BS, int thread_bs) {
    int bid_cnt = 0;
    
    double2* shared = (double2*) ext_shared;
    int threadblock_per_SM = 2;
    int tb_gap = threadblock_per_SM * 108;
    int delta_bid = ((blockIdx.x / tb_gap) ==  (gridDim.x / tb_gap)) ? (gridDim.x % tb_gap) : tb_gap;
    double2 r[3];
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
    double2* gPtr;
    double2* shPtr;
    double2 rPtr[16];
    double2 rPtr_2[16];
    double2 rPtr_3[16];
    double2 rPtr_4[16];
    double2 tmp;
    double2 tmp_1;
    double2 tmp_2;
    double2 tmp_3;
    double2 angle;
    double2 delta_angle;
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
                bid_cnt < thread_bs && bid < (536870912 * BS + 8192 - 1) / 8192; bid += delta_bid)
    {
    bid_cnt += 1;
            
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
        rPtr[0] = *(gPtr + 0);
        rPtr_3[0].x += rPtr[0].x;
        rPtr_3[0].y += rPtr[0].y;
        
        rPtr[1] = *(gPtr + 32768);
        rPtr_3[1].x += rPtr[1].x;
        rPtr_3[1].y += rPtr[1].y;
        
        rPtr[2] = *(gPtr + 65536);
        rPtr_3[2].x += rPtr[2].x;
        rPtr_3[2].y += rPtr[2].y;
        
        rPtr[3] = *(gPtr + 98304);
        rPtr_3[3].x += rPtr[3].x;
        rPtr_3[3].y += rPtr[3].y;
        
        rPtr[4] = *(gPtr + 131072);
        rPtr_3[4].x += rPtr[4].x;
        rPtr_3[4].y += rPtr[4].y;
        
        rPtr[5] = *(gPtr + 163840);
        rPtr_3[5].x += rPtr[5].x;
        rPtr_3[5].y += rPtr[5].y;
        
        rPtr[6] = *(gPtr + 196608);
        rPtr_3[6].x += rPtr[6].x;
        rPtr_3[6].y += rPtr[6].y;
        
        rPtr[7] = *(gPtr + 229376);
        rPtr_3[7].x += rPtr[7].x;
        rPtr_3[7].y += rPtr[7].y;
        
        rPtr[8] = *(gPtr + 262144);
        rPtr_3[8].x += rPtr[8].x;
        rPtr_3[8].y += rPtr[8].y;
        
        rPtr[9] = *(gPtr + 294912);
        rPtr_3[9].x += rPtr[9].x;
        rPtr_3[9].y += rPtr[9].y;
        
        rPtr[10] = *(gPtr + 327680);
        rPtr_3[10].x += rPtr[10].x;
        rPtr_3[10].y += rPtr[10].y;
        
        rPtr[11] = *(gPtr + 360448);
        rPtr_3[11].x += rPtr[11].x;
        rPtr_3[11].y += rPtr[11].y;
        
        rPtr[12] = *(gPtr + 393216);
        rPtr_3[12].x += rPtr[12].x;
        rPtr_3[12].y += rPtr[12].y;
        
        rPtr[13] = *(gPtr + 425984);
        rPtr_3[13].x += rPtr[13].x;
        rPtr_3[13].y += rPtr[13].y;
        
        rPtr[14] = *(gPtr + 458752);
        rPtr_3[14].x += rPtr[14].x;
        rPtr_3[14].y += rPtr[14].y;
        
        rPtr[15] = *(gPtr + 491520);
        rPtr_3[15].x += rPtr[15].x;
        rPtr_3[15].y += rPtr[15].y;
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 4) * 128;
    
    offset += ((tx / 32) % 16) * 512;
    
    __syncthreads();
    
    delta_angle = twiddle[1023 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 8] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 16] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 24] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 32] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 40] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 48] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 56] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 64] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 72] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 80] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 88] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 96] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 104] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 112] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 120] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    offset += ((tx / 8) % 16) * 8;
    
    j = tx / 128;
    
    offset += ((tx / 128) % 4) * 2048;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 128] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 256] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 384] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 512] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 640] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 768] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 896] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1024] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 1152] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1280] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 1408] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1536] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 1664] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1792] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 1920] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    rPtr[13].y = -tmp.x;
    rPtr[13].x = tmp.y;
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    global_j = 0;
    global_k = 0;
    
    global_j += (bx % 64) * 8 * 1;
    
    global_j += (tx % 8) * 1;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
    global_k += tx / 8;
    
        delta_angle = twiddle[524287 + global_j * (64)];
        angle = twiddle[524287 + global_j * global_k];
        
            tmp = rPtr[0];
            turboFFT_ZMUL(rPtr[0], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[1];
            turboFFT_ZMUL(rPtr[1], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[2];
            turboFFT_ZMUL(rPtr[2], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[3];
            turboFFT_ZMUL(rPtr[3], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[8];
            turboFFT_ZMUL(rPtr[8], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[9];
            turboFFT_ZMUL(rPtr[9], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[10];
            turboFFT_ZMUL(rPtr[10], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[11];
            turboFFT_ZMUL(rPtr[11], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[4];
            turboFFT_ZMUL(rPtr[4], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[5];
            turboFFT_ZMUL(rPtr[5], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[6];
            turboFFT_ZMUL(rPtr[6], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[7];
            turboFFT_ZMUL(rPtr[7], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[12];
            turboFFT_ZMUL(rPtr[12], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[13];
            turboFFT_ZMUL(rPtr[13], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[14];
            turboFFT_ZMUL(rPtr[14], tmp, angle);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[15];
            turboFFT_ZMUL(rPtr[15], tmp, angle);
            
            *(gPtr + 0) = rPtr[0];
            rPtr_4[0].x += rPtr[0].x;
            rPtr_4[0].y += rPtr[0].y;
            
            *(gPtr + 32768) = rPtr[1];
            rPtr_4[1].x += rPtr[1].x;
            rPtr_4[1].y += rPtr[1].y;
            
            *(gPtr + 65536) = rPtr[2];
            rPtr_4[2].x += rPtr[2].x;
            rPtr_4[2].y += rPtr[2].y;
            
            *(gPtr + 98304) = rPtr[3];
            rPtr_4[3].x += rPtr[3].x;
            rPtr_4[3].y += rPtr[3].y;
            
            *(gPtr + 131072) = rPtr[8];
            rPtr_4[4].x += rPtr[8].x;
            rPtr_4[4].y += rPtr[8].y;
            
            *(gPtr + 163840) = rPtr[9];
            rPtr_4[5].x += rPtr[9].x;
            rPtr_4[5].y += rPtr[9].y;
            
            *(gPtr + 196608) = rPtr[10];
            rPtr_4[6].x += rPtr[10].x;
            rPtr_4[6].y += rPtr[10].y;
            
            *(gPtr + 229376) = rPtr[11];
            rPtr_4[7].x += rPtr[11].x;
            rPtr_4[7].y += rPtr[11].y;
            
            *(gPtr + 262144) = rPtr[4];
            rPtr_4[8].x += rPtr[4].x;
            rPtr_4[8].y += rPtr[4].y;
            
            *(gPtr + 294912) = rPtr[5];
            rPtr_4[9].x += rPtr[5].x;
            rPtr_4[9].y += rPtr[5].y;
            
            *(gPtr + 327680) = rPtr[6];
            rPtr_4[10].x += rPtr[6].x;
            rPtr_4[10].y += rPtr[6].y;
            
            *(gPtr + 360448) = rPtr[7];
            rPtr_4[11].x += rPtr[7].x;
            rPtr_4[11].y += rPtr[7].y;
            
            *(gPtr + 393216) = rPtr[12];
            rPtr_4[12].x += rPtr[12].x;
            rPtr_4[12].y += rPtr[12].y;
            
            *(gPtr + 425984) = rPtr[13];
            rPtr_4[13].x += rPtr[13].x;
            rPtr_4[13].y += rPtr[13].y;
            
            *(gPtr + 458752) = rPtr[14];
            rPtr_4[14].x += rPtr[14].x;
            rPtr_4[14].y += rPtr[14].y;
            
            *(gPtr + 491520) = rPtr[15];
            rPtr_4[15].x += rPtr[15].x;
            rPtr_4[15].y += rPtr[15].y;
            
    }
    
}

#include "../../../TurboFFT_radix_2_template.h"
template<>
__global__ void fft_radix_2<double2, 29, 1, 1, 0>(double2* inputs, double2* outputs, double2* twiddle, double2* checksum_DFT, int BS, int thread_bs) {
    int bid_cnt = 0;
    
    double2* shared = (double2*) ext_shared;
    int threadblock_per_SM = 2;
    int tb_gap = threadblock_per_SM * 108;
    int delta_bid = ((blockIdx.x / tb_gap) ==  (gridDim.x / tb_gap)) ? (gridDim.x % tb_gap) : tb_gap;
    double2 r[3];
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
    double2* gPtr;
    double2* shPtr;
    double2 rPtr[16];
    double2 rPtr_2[16];
    double2 rPtr_3[16];
    double2 rPtr_4[16];
    double2 tmp;
    double2 tmp_1;
    double2 tmp_2;
    double2 tmp_3;
    double2 angle;
    double2 delta_angle;
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
    
    rPtr_2[0] = *(checksum_DFT + 1024 - 2 + tx + 0);
    shPtr[tx + 0] = rPtr_2[0];
    
    rPtr_2[1] = *(checksum_DFT + 1024 - 2 + tx + 512);
    shPtr[tx + 512] = rPtr_2[1];
    
    __syncthreads();
    tmp_1.x = 0;
    tmp_1.y = 0;
    tmp_2.x = 0;
    tmp_2.y = 0;
    tmp_3.x = 0;
    tmp_3.y = 0;
    
    rPtr_2[0] = *(shPtr +  tx / 8 + 0);
    rPtr_3[0].x = 0; rPtr_3[0].y = 0;
    rPtr_4[0].x = 0; rPtr_4[0].y = 0;
    
    rPtr_2[1] = *(shPtr +  tx / 8 + 64);
    rPtr_3[1].x = 0; rPtr_3[1].y = 0;
    rPtr_4[1].x = 0; rPtr_4[1].y = 0;
    
    rPtr_2[2] = *(shPtr +  tx / 8 + 128);
    rPtr_3[2].x = 0; rPtr_3[2].y = 0;
    rPtr_4[2].x = 0; rPtr_4[2].y = 0;
    
    rPtr_2[3] = *(shPtr +  tx / 8 + 192);
    rPtr_3[3].x = 0; rPtr_3[3].y = 0;
    rPtr_4[3].x = 0; rPtr_4[3].y = 0;
    
    rPtr_2[4] = *(shPtr +  tx / 8 + 256);
    rPtr_3[4].x = 0; rPtr_3[4].y = 0;
    rPtr_4[4].x = 0; rPtr_4[4].y = 0;
    
    rPtr_2[5] = *(shPtr +  tx / 8 + 320);
    rPtr_3[5].x = 0; rPtr_3[5].y = 0;
    rPtr_4[5].x = 0; rPtr_4[5].y = 0;
    
    rPtr_2[6] = *(shPtr +  tx / 8 + 384);
    rPtr_3[6].x = 0; rPtr_3[6].y = 0;
    rPtr_4[6].x = 0; rPtr_4[6].y = 0;
    
    rPtr_2[7] = *(shPtr +  tx / 8 + 448);
    rPtr_3[7].x = 0; rPtr_3[7].y = 0;
    rPtr_4[7].x = 0; rPtr_4[7].y = 0;
    
    rPtr_2[8] = *(shPtr +  tx / 8 + 512);
    rPtr_3[8].x = 0; rPtr_3[8].y = 0;
    rPtr_4[8].x = 0; rPtr_4[8].y = 0;
    
    rPtr_2[9] = *(shPtr +  tx / 8 + 576);
    rPtr_3[9].x = 0; rPtr_3[9].y = 0;
    rPtr_4[9].x = 0; rPtr_4[9].y = 0;
    
    rPtr_2[10] = *(shPtr +  tx / 8 + 640);
    rPtr_3[10].x = 0; rPtr_3[10].y = 0;
    rPtr_4[10].x = 0; rPtr_4[10].y = 0;
    
    rPtr_2[11] = *(shPtr +  tx / 8 + 704);
    rPtr_3[11].x = 0; rPtr_3[11].y = 0;
    rPtr_4[11].x = 0; rPtr_4[11].y = 0;
    
    rPtr_2[12] = *(shPtr +  tx / 8 + 768);
    rPtr_3[12].x = 0; rPtr_3[12].y = 0;
    rPtr_4[12].x = 0; rPtr_4[12].y = 0;
    
    rPtr_2[13] = *(shPtr +  tx / 8 + 832);
    rPtr_3[13].x = 0; rPtr_3[13].y = 0;
    rPtr_4[13].x = 0; rPtr_4[13].y = 0;
    
    rPtr_2[14] = *(shPtr +  tx / 8 + 896);
    rPtr_3[14].x = 0; rPtr_3[14].y = 0;
    rPtr_4[14].x = 0; rPtr_4[14].y = 0;
    
    rPtr_2[15] = *(shPtr +  tx / 8 + 960);
    rPtr_3[15].x = 0; rPtr_3[15].y = 0;
    rPtr_4[15].x = 0; rPtr_4[15].y = 0;
    
    __syncthreads();
    int bid = 0;
    for(bid = (blockIdx.x / tb_gap) * tb_gap * thread_bs + blockIdx.x % tb_gap;
                bid_cnt < thread_bs && bid < (536870912 * BS + 8192 - 1) / 8192; bid += delta_bid)
    {
    bid_cnt += 1;
            
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
        rPtr[0] = *(gPtr + 0);
        rPtr_3[0].x += rPtr[0].x;
        rPtr_3[0].y += rPtr[0].y;
        
        // tmp = checksum_DFT[tx / 8 + 0];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[0], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[0], rPtr_2[0])
        turboFFT_ZMUL(tmp, rPtr[0], rPtr_2[0])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[1] = *(gPtr + 32768);
        rPtr_3[1].x += rPtr[1].x;
        rPtr_3[1].y += rPtr[1].y;
        
        // tmp = checksum_DFT[tx / 8 + 64];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[1], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[1], rPtr_2[1])
        turboFFT_ZMUL(tmp, rPtr[1], rPtr_2[1])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[2] = *(gPtr + 65536);
        rPtr_3[2].x += rPtr[2].x;
        rPtr_3[2].y += rPtr[2].y;
        
        // tmp = checksum_DFT[tx / 8 + 128];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[2], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[2], rPtr_2[2])
        turboFFT_ZMUL(tmp, rPtr[2], rPtr_2[2])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[3] = *(gPtr + 98304);
        rPtr_3[3].x += rPtr[3].x;
        rPtr_3[3].y += rPtr[3].y;
        
        // tmp = checksum_DFT[tx / 8 + 192];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[3], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[3], rPtr_2[3])
        turboFFT_ZMUL(tmp, rPtr[3], rPtr_2[3])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[4] = *(gPtr + 131072);
        rPtr_3[4].x += rPtr[4].x;
        rPtr_3[4].y += rPtr[4].y;
        
        // tmp = checksum_DFT[tx / 8 + 256];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[4], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[4], rPtr_2[4])
        turboFFT_ZMUL(tmp, rPtr[4], rPtr_2[4])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[5] = *(gPtr + 163840);
        rPtr_3[5].x += rPtr[5].x;
        rPtr_3[5].y += rPtr[5].y;
        
        // tmp = checksum_DFT[tx / 8 + 320];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[5], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[5], rPtr_2[5])
        turboFFT_ZMUL(tmp, rPtr[5], rPtr_2[5])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[6] = *(gPtr + 196608);
        rPtr_3[6].x += rPtr[6].x;
        rPtr_3[6].y += rPtr[6].y;
        
        // tmp = checksum_DFT[tx / 8 + 384];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[6], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[6], rPtr_2[6])
        turboFFT_ZMUL(tmp, rPtr[6], rPtr_2[6])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[7] = *(gPtr + 229376);
        rPtr_3[7].x += rPtr[7].x;
        rPtr_3[7].y += rPtr[7].y;
        
        // tmp = checksum_DFT[tx / 8 + 448];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[7], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[7], rPtr_2[7])
        turboFFT_ZMUL(tmp, rPtr[7], rPtr_2[7])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[8] = *(gPtr + 262144);
        rPtr_3[8].x += rPtr[8].x;
        rPtr_3[8].y += rPtr[8].y;
        
        // tmp = checksum_DFT[tx / 8 + 512];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[8], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[8], rPtr_2[8])
        turboFFT_ZMUL(tmp, rPtr[8], rPtr_2[8])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[9] = *(gPtr + 294912);
        rPtr_3[9].x += rPtr[9].x;
        rPtr_3[9].y += rPtr[9].y;
        
        // tmp = checksum_DFT[tx / 8 + 576];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[9], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[9], rPtr_2[9])
        turboFFT_ZMUL(tmp, rPtr[9], rPtr_2[9])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[10] = *(gPtr + 327680);
        rPtr_3[10].x += rPtr[10].x;
        rPtr_3[10].y += rPtr[10].y;
        
        // tmp = checksum_DFT[tx / 8 + 640];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[10], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[10], rPtr_2[10])
        turboFFT_ZMUL(tmp, rPtr[10], rPtr_2[10])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[11] = *(gPtr + 360448);
        rPtr_3[11].x += rPtr[11].x;
        rPtr_3[11].y += rPtr[11].y;
        
        // tmp = checksum_DFT[tx / 8 + 704];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[11], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[11], rPtr_2[11])
        turboFFT_ZMUL(tmp, rPtr[11], rPtr_2[11])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[12] = *(gPtr + 393216);
        rPtr_3[12].x += rPtr[12].x;
        rPtr_3[12].y += rPtr[12].y;
        
        // tmp = checksum_DFT[tx / 8 + 768];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[12], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[12], rPtr_2[12])
        turboFFT_ZMUL(tmp, rPtr[12], rPtr_2[12])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[13] = *(gPtr + 425984);
        rPtr_3[13].x += rPtr[13].x;
        rPtr_3[13].y += rPtr[13].y;
        
        // tmp = checksum_DFT[tx / 8 + 832];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[13], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[13], rPtr_2[13])
        turboFFT_ZMUL(tmp, rPtr[13], rPtr_2[13])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[14] = *(gPtr + 458752);
        rPtr_3[14].x += rPtr[14].x;
        rPtr_3[14].y += rPtr[14].y;
        
        // tmp = checksum_DFT[tx / 8 + 896];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[14], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[14], rPtr_2[14])
        turboFFT_ZMUL(tmp, rPtr[14], rPtr_2[14])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[15] = *(gPtr + 491520);
        rPtr_3[15].x += rPtr[15].x;
        rPtr_3[15].y += rPtr[15].y;
        
        // tmp = checksum_DFT[tx / 8 + 960];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[15], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[15], rPtr_2[15])
        turboFFT_ZMUL(tmp, rPtr[15], rPtr_2[15])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        // tmp_3.x += bid_cnt * (rPtr[0].x + rPtr[0].y) * 1024;
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 4) * 128;
    
    offset += ((tx / 32) % 16) * 512;
    
    __syncthreads();
    
    delta_angle = twiddle[1023 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 8] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 16] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 24] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 32] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 40] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 48] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 56] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 64] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 72] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 80] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 88] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 96] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 104] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 112] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 120] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    offset += ((tx / 8) % 16) * 8;
    
    j = tx / 128;
    
    offset += ((tx / 128) % 4) * 2048;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 128] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 256] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 384] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 512] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 640] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 768] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 896] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1024] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 1152] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1280] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 1408] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1536] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 1664] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1792] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 1920] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    rPtr[13].y = -tmp.x;
    rPtr[13].x = tmp.y;
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    global_j = 0;
    global_k = 0;
    
    global_j += (bx % 64) * 8 * 1;
    
    global_j += (tx % 8) * 1;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
    global_k += tx / 8;
    
        // 1's vector
        // tmp_3.y -=  (rPtr[0].y + rPtr[0].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[0].y + rPtr[0].x);
        turboFFT_ZMUL(tmp, rPtr[0],r[(0 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[0], r[(0 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[0], r[(0 + tx / 8) % 3])
        
        delta_angle = twiddle[524287 + global_j * (64)];
        angle = twiddle[524287 + global_j * global_k];
        
            tmp = rPtr[0];
            turboFFT_ZMUL(rPtr[0], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[1].y + rPtr[1].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[1].y + rPtr[1].x);
        turboFFT_ZMUL(tmp, rPtr[1],r[(64 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[1], r[(64 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[1], r[(64 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[1];
            turboFFT_ZMUL(rPtr[1], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[2].y + rPtr[2].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[2].y + rPtr[2].x);
        turboFFT_ZMUL(tmp, rPtr[2],r[(128 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[2], r[(128 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[2], r[(128 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[2];
            turboFFT_ZMUL(rPtr[2], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[3].y + rPtr[3].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[3].y + rPtr[3].x);
        turboFFT_ZMUL(tmp, rPtr[3],r[(192 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[3], r[(192 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[3], r[(192 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[3];
            turboFFT_ZMUL(rPtr[3], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[8].y + rPtr[8].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[8].y + rPtr[8].x);
        turboFFT_ZMUL(tmp, rPtr[8],r[(256 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[8], r[(256 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[8], r[(256 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[8];
            turboFFT_ZMUL(rPtr[8], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[9].y + rPtr[9].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[9].y + rPtr[9].x);
        turboFFT_ZMUL(tmp, rPtr[9],r[(320 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[9], r[(320 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[9], r[(320 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[9];
            turboFFT_ZMUL(rPtr[9], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[10].y + rPtr[10].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[10].y + rPtr[10].x);
        turboFFT_ZMUL(tmp, rPtr[10],r[(384 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[10], r[(384 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[10], r[(384 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[10];
            turboFFT_ZMUL(rPtr[10], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[11].y + rPtr[11].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[11].y + rPtr[11].x);
        turboFFT_ZMUL(tmp, rPtr[11],r[(448 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[11], r[(448 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[11], r[(448 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[11];
            turboFFT_ZMUL(rPtr[11], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[4].y + rPtr[4].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[4].y + rPtr[4].x);
        turboFFT_ZMUL(tmp, rPtr[4],r[(512 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[4], r[(512 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[4], r[(512 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[4];
            turboFFT_ZMUL(rPtr[4], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[5].y + rPtr[5].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[5].y + rPtr[5].x);
        turboFFT_ZMUL(tmp, rPtr[5],r[(576 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[5], r[(576 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[5], r[(576 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[5];
            turboFFT_ZMUL(rPtr[5], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[6].y + rPtr[6].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[6].y + rPtr[6].x);
        turboFFT_ZMUL(tmp, rPtr[6],r[(640 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[6], r[(640 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[6], r[(640 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[6];
            turboFFT_ZMUL(rPtr[6], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[7].y + rPtr[7].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[7].y + rPtr[7].x);
        turboFFT_ZMUL(tmp, rPtr[7],r[(704 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[7], r[(704 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[7], r[(704 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[7];
            turboFFT_ZMUL(rPtr[7], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[12].y + rPtr[12].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[12].y + rPtr[12].x);
        turboFFT_ZMUL(tmp, rPtr[12],r[(768 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[12], r[(768 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[12], r[(768 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[12];
            turboFFT_ZMUL(rPtr[12], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[13].y + rPtr[13].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[13].y + rPtr[13].x);
        turboFFT_ZMUL(tmp, rPtr[13],r[(832 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[13], r[(832 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[13], r[(832 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[13];
            turboFFT_ZMUL(rPtr[13], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[14].y + rPtr[14].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[14].y + rPtr[14].x);
        turboFFT_ZMUL(tmp, rPtr[14],r[(896 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[14], r[(896 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[14], r[(896 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[14];
            turboFFT_ZMUL(rPtr[14], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[15].y + rPtr[15].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[15].y + rPtr[15].x);
        turboFFT_ZMUL(tmp, rPtr[15],r[(960 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[15], r[(960 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[15], r[(960 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[15];
            turboFFT_ZMUL(rPtr[15], tmp, angle);
            
            *(gPtr + 0) = rPtr[0];
            rPtr_4[0].x += rPtr[0].x;
            rPtr_4[0].y += rPtr[0].y;
            
            *(gPtr + 32768) = rPtr[1];
            rPtr_4[1].x += rPtr[1].x;
            rPtr_4[1].y += rPtr[1].y;
            
            *(gPtr + 65536) = rPtr[2];
            rPtr_4[2].x += rPtr[2].x;
            rPtr_4[2].y += rPtr[2].y;
            
            *(gPtr + 98304) = rPtr[3];
            rPtr_4[3].x += rPtr[3].x;
            rPtr_4[3].y += rPtr[3].y;
            
            *(gPtr + 131072) = rPtr[8];
            rPtr_4[4].x += rPtr[8].x;
            rPtr_4[4].y += rPtr[8].y;
            
            *(gPtr + 163840) = rPtr[9];
            rPtr_4[5].x += rPtr[9].x;
            rPtr_4[5].y += rPtr[9].y;
            
            *(gPtr + 196608) = rPtr[10];
            rPtr_4[6].x += rPtr[10].x;
            rPtr_4[6].y += rPtr[10].y;
            
            *(gPtr + 229376) = rPtr[11];
            rPtr_4[7].x += rPtr[11].x;
            rPtr_4[7].y += rPtr[11].y;
            
            *(gPtr + 262144) = rPtr[4];
            rPtr_4[8].x += rPtr[4].x;
            rPtr_4[8].y += rPtr[4].y;
            
            *(gPtr + 294912) = rPtr[5];
            rPtr_4[9].x += rPtr[5].x;
            rPtr_4[9].y += rPtr[5].y;
            
            *(gPtr + 327680) = rPtr[6];
            rPtr_4[10].x += rPtr[6].x;
            rPtr_4[10].y += rPtr[6].y;
            
            *(gPtr + 360448) = rPtr[7];
            rPtr_4[11].x += rPtr[7].x;
            rPtr_4[11].y += rPtr[7].y;
            
            *(gPtr + 393216) = rPtr[12];
            rPtr_4[12].x += rPtr[12].x;
            rPtr_4[12].y += rPtr[12].y;
            
            *(gPtr + 425984) = rPtr[13];
            rPtr_4[13].x += rPtr[13].x;
            rPtr_4[13].y += rPtr[13].y;
            
            *(gPtr + 458752) = rPtr[14];
            rPtr_4[14].x += rPtr[14].x;
            rPtr_4[14].y += rPtr[14].y;
            
            *(gPtr + 491520) = rPtr[15];
            rPtr_4[15].x += rPtr[15].x;
            rPtr_4[15].y += rPtr[15].y;
            
        if(bid_cnt==thread_bs)
        
        {
        
        // 1's vector
        // tmp.x = (tx / 8 == 0) ? (rPtr_3[0].y + rPtr_3[0].x) * 1024: 0;
        // tmp.y = (tx / 8 == 0) ? (abs(rPtr_3[0].y) + abs(rPtr_3[0].x)) * 1024: 0;
        tmp = tmp_1;
        tmp_1.y += tmp.x;
        tmp_1.x = (abs(tmp.y) + abs(tmp.x));
        
        // 1's vector
        // tmp.x = (tx / 8 == 0) ? tmp_3.x : 0;
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
        
            tmp_1 = shPtr[(tx % 16) * 2];
            tmp_3 = shPtr[(tx % 16) * 2 + 1];
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 8, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 8, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 8, 32);
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 4, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 4, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 4, 32);
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 2, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 2, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 2, 32);
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 1, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 1, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 1, 32);
        
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(tx == 0)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if((blockIdx.x % thread_bs + 1) != round(abs(tmp_3.y) / abs(tmp_1.y)) && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 )  printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            //                                         bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x, tmp_3.y, tmp_3.y / tmp_1.y);
            // if(abs(tmp_1.y / tmp_1.x) > 0.001)printf("1, bid=%d bx=%d, by=%d, tx=%d: %f, %f, %f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
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
__global__ void fft_radix_2<double2, 29, 1, 1, 1>(double2* inputs, double2* outputs, double2* twiddle, double2* checksum_DFT, int BS, int thread_bs) {
    int bid_cnt = 0;
    
    double2* shared = (double2*) ext_shared;
    int threadblock_per_SM = 2;
    int tb_gap = threadblock_per_SM * 108;
    int delta_bid = ((blockIdx.x / tb_gap) ==  (gridDim.x / tb_gap)) ? (gridDim.x % tb_gap) : tb_gap;
    double2 r[3];
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
    double2* gPtr;
    double2* shPtr;
    double2 rPtr[16];
    double2 rPtr_2[16];
    double2 rPtr_3[16];
    double2 rPtr_4[16];
    double2 tmp;
    double2 tmp_1;
    double2 tmp_2;
    double2 tmp_3;
    double2 angle;
    double2 delta_angle;
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
    
    rPtr_2[0] = *(checksum_DFT + 1024 - 2 + tx + 0);
    shPtr[tx + 0] = rPtr_2[0];
    
    rPtr_2[1] = *(checksum_DFT + 1024 - 2 + tx + 512);
    shPtr[tx + 512] = rPtr_2[1];
    
    __syncthreads();
    tmp_1.x = 0;
    tmp_1.y = 0;
    tmp_2.x = 0;
    tmp_2.y = 0;
    tmp_3.x = 0;
    tmp_3.y = 0;
    
    rPtr_2[0] = *(shPtr +  tx / 8 + 0);
    rPtr_3[0].x = 0; rPtr_3[0].y = 0;
    rPtr_4[0].x = 0; rPtr_4[0].y = 0;
    
    rPtr_2[1] = *(shPtr +  tx / 8 + 64);
    rPtr_3[1].x = 0; rPtr_3[1].y = 0;
    rPtr_4[1].x = 0; rPtr_4[1].y = 0;
    
    rPtr_2[2] = *(shPtr +  tx / 8 + 128);
    rPtr_3[2].x = 0; rPtr_3[2].y = 0;
    rPtr_4[2].x = 0; rPtr_4[2].y = 0;
    
    rPtr_2[3] = *(shPtr +  tx / 8 + 192);
    rPtr_3[3].x = 0; rPtr_3[3].y = 0;
    rPtr_4[3].x = 0; rPtr_4[3].y = 0;
    
    rPtr_2[4] = *(shPtr +  tx / 8 + 256);
    rPtr_3[4].x = 0; rPtr_3[4].y = 0;
    rPtr_4[4].x = 0; rPtr_4[4].y = 0;
    
    rPtr_2[5] = *(shPtr +  tx / 8 + 320);
    rPtr_3[5].x = 0; rPtr_3[5].y = 0;
    rPtr_4[5].x = 0; rPtr_4[5].y = 0;
    
    rPtr_2[6] = *(shPtr +  tx / 8 + 384);
    rPtr_3[6].x = 0; rPtr_3[6].y = 0;
    rPtr_4[6].x = 0; rPtr_4[6].y = 0;
    
    rPtr_2[7] = *(shPtr +  tx / 8 + 448);
    rPtr_3[7].x = 0; rPtr_3[7].y = 0;
    rPtr_4[7].x = 0; rPtr_4[7].y = 0;
    
    rPtr_2[8] = *(shPtr +  tx / 8 + 512);
    rPtr_3[8].x = 0; rPtr_3[8].y = 0;
    rPtr_4[8].x = 0; rPtr_4[8].y = 0;
    
    rPtr_2[9] = *(shPtr +  tx / 8 + 576);
    rPtr_3[9].x = 0; rPtr_3[9].y = 0;
    rPtr_4[9].x = 0; rPtr_4[9].y = 0;
    
    rPtr_2[10] = *(shPtr +  tx / 8 + 640);
    rPtr_3[10].x = 0; rPtr_3[10].y = 0;
    rPtr_4[10].x = 0; rPtr_4[10].y = 0;
    
    rPtr_2[11] = *(shPtr +  tx / 8 + 704);
    rPtr_3[11].x = 0; rPtr_3[11].y = 0;
    rPtr_4[11].x = 0; rPtr_4[11].y = 0;
    
    rPtr_2[12] = *(shPtr +  tx / 8 + 768);
    rPtr_3[12].x = 0; rPtr_3[12].y = 0;
    rPtr_4[12].x = 0; rPtr_4[12].y = 0;
    
    rPtr_2[13] = *(shPtr +  tx / 8 + 832);
    rPtr_3[13].x = 0; rPtr_3[13].y = 0;
    rPtr_4[13].x = 0; rPtr_4[13].y = 0;
    
    rPtr_2[14] = *(shPtr +  tx / 8 + 896);
    rPtr_3[14].x = 0; rPtr_3[14].y = 0;
    rPtr_4[14].x = 0; rPtr_4[14].y = 0;
    
    rPtr_2[15] = *(shPtr +  tx / 8 + 960);
    rPtr_3[15].x = 0; rPtr_3[15].y = 0;
    rPtr_4[15].x = 0; rPtr_4[15].y = 0;
    
    __syncthreads();
    int bid = 0;
    for(bid = (blockIdx.x / tb_gap) * tb_gap * thread_bs + blockIdx.x % tb_gap;
                bid_cnt < thread_bs && bid < (536870912 * BS + 8192 - 1) / 8192; bid += delta_bid)
    {
    bid_cnt += 1;
            
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
        rPtr[0] = *(gPtr + 0);
        rPtr_3[0].x += rPtr[0].x;
        rPtr_3[0].y += rPtr[0].y;
        
        // tmp = checksum_DFT[tx / 8 + 0];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[0], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[0], rPtr_2[0])
        turboFFT_ZMUL(tmp, rPtr[0], rPtr_2[0])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[1] = *(gPtr + 32768);
        rPtr_3[1].x += rPtr[1].x;
        rPtr_3[1].y += rPtr[1].y;
        
        // tmp = checksum_DFT[tx / 8 + 64];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[1], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[1], rPtr_2[1])
        turboFFT_ZMUL(tmp, rPtr[1], rPtr_2[1])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[2] = *(gPtr + 65536);
        rPtr_3[2].x += rPtr[2].x;
        rPtr_3[2].y += rPtr[2].y;
        
        // tmp = checksum_DFT[tx / 8 + 128];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[2], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[2], rPtr_2[2])
        turboFFT_ZMUL(tmp, rPtr[2], rPtr_2[2])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[3] = *(gPtr + 98304);
        rPtr_3[3].x += rPtr[3].x;
        rPtr_3[3].y += rPtr[3].y;
        
        // tmp = checksum_DFT[tx / 8 + 192];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[3], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[3], rPtr_2[3])
        turboFFT_ZMUL(tmp, rPtr[3], rPtr_2[3])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[4] = *(gPtr + 131072);
        rPtr_3[4].x += rPtr[4].x;
        rPtr_3[4].y += rPtr[4].y;
        
        // tmp = checksum_DFT[tx / 8 + 256];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[4], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[4], rPtr_2[4])
        turboFFT_ZMUL(tmp, rPtr[4], rPtr_2[4])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[5] = *(gPtr + 163840);
        rPtr_3[5].x += rPtr[5].x;
        rPtr_3[5].y += rPtr[5].y;
        
        // tmp = checksum_DFT[tx / 8 + 320];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[5], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[5], rPtr_2[5])
        turboFFT_ZMUL(tmp, rPtr[5], rPtr_2[5])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[6] = *(gPtr + 196608);
        rPtr_3[6].x += rPtr[6].x;
        rPtr_3[6].y += rPtr[6].y;
        
        // tmp = checksum_DFT[tx / 8 + 384];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[6], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[6], rPtr_2[6])
        turboFFT_ZMUL(tmp, rPtr[6], rPtr_2[6])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[7] = *(gPtr + 229376);
        rPtr_3[7].x += rPtr[7].x;
        rPtr_3[7].y += rPtr[7].y;
        
        // tmp = checksum_DFT[tx / 8 + 448];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[7], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[7], rPtr_2[7])
        turboFFT_ZMUL(tmp, rPtr[7], rPtr_2[7])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[8] = *(gPtr + 262144);
        rPtr_3[8].x += rPtr[8].x;
        rPtr_3[8].y += rPtr[8].y;
        
        // tmp = checksum_DFT[tx / 8 + 512];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[8], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[8], rPtr_2[8])
        turboFFT_ZMUL(tmp, rPtr[8], rPtr_2[8])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[9] = *(gPtr + 294912);
        rPtr_3[9].x += rPtr[9].x;
        rPtr_3[9].y += rPtr[9].y;
        
        // tmp = checksum_DFT[tx / 8 + 576];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[9], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[9], rPtr_2[9])
        turboFFT_ZMUL(tmp, rPtr[9], rPtr_2[9])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[10] = *(gPtr + 327680);
        rPtr_3[10].x += rPtr[10].x;
        rPtr_3[10].y += rPtr[10].y;
        
        // tmp = checksum_DFT[tx / 8 + 640];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[10], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[10], rPtr_2[10])
        turboFFT_ZMUL(tmp, rPtr[10], rPtr_2[10])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[11] = *(gPtr + 360448);
        rPtr_3[11].x += rPtr[11].x;
        rPtr_3[11].y += rPtr[11].y;
        
        // tmp = checksum_DFT[tx / 8 + 704];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[11], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[11], rPtr_2[11])
        turboFFT_ZMUL(tmp, rPtr[11], rPtr_2[11])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[12] = *(gPtr + 393216);
        rPtr_3[12].x += rPtr[12].x;
        rPtr_3[12].y += rPtr[12].y;
        
        // tmp = checksum_DFT[tx / 8 + 768];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[12], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[12], rPtr_2[12])
        turboFFT_ZMUL(tmp, rPtr[12], rPtr_2[12])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[13] = *(gPtr + 425984);
        rPtr_3[13].x += rPtr[13].x;
        rPtr_3[13].y += rPtr[13].y;
        
        // tmp = checksum_DFT[tx / 8 + 832];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[13], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[13], rPtr_2[13])
        turboFFT_ZMUL(tmp, rPtr[13], rPtr_2[13])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[14] = *(gPtr + 458752);
        rPtr_3[14].x += rPtr[14].x;
        rPtr_3[14].y += rPtr[14].y;
        
        // tmp = checksum_DFT[tx / 8 + 896];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[14], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[14], rPtr_2[14])
        turboFFT_ZMUL(tmp, rPtr[14], rPtr_2[14])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        rPtr[15] = *(gPtr + 491520);
        rPtr_3[15].x += rPtr[15].x;
        rPtr_3[15].y += rPtr[15].y;
        
        // tmp = checksum_DFT[tx / 8 + 960];
        // turboFFT_ZMUL_ACC(tmp_1, rPtr[15], tmp);
        //  turboFFT_ZMUL_ACC(tmp_1, rPtr[15], rPtr_2[15])
        turboFFT_ZMUL(tmp, rPtr[15], rPtr_2[15])
        tmp_1.x += (tmp.x + tmp.y);
        tmp_3.x += bid_cnt * (tmp.x + tmp.y);
        
        // tmp_3.x += bid_cnt * (rPtr[0].x + rPtr[0].y) * 1024;
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 4) * 128;
    
    offset += ((tx / 32) % 16) * 512;
    
    __syncthreads();
    
    delta_angle = twiddle[1023 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 8] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 16] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 24] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 32] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 40] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 48] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 56] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 64] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 72] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 80] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 88] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 96] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 104] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 112] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 120] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    offset += ((tx / 8) % 16) * 8;
    
    j = tx / 128;
    
    offset += ((tx / 128) % 4) * 2048;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 128] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 256] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 384] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 512] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 640] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 768] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 896] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1024] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 1152] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1280] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 1408] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1536] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 1664] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1792] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 1920] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    rPtr[13].y = -tmp.x;
    rPtr[13].x = tmp.y;
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    global_j = 0;
    global_k = 0;
    
    global_j += (bx % 64) * 8 * 1;
    
    global_j += (tx % 8) * 1;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
    global_k += tx / 8;
    
        // 1's vector
        // tmp_3.y -=  (rPtr[0].y + rPtr[0].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[0].y + rPtr[0].x);
        turboFFT_ZMUL(tmp, rPtr[0],r[(0 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[0], r[(0 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[0], r[(0 + tx / 8) % 3])
        
        delta_angle = twiddle[524287 + global_j * (64)];
        angle = twiddle[524287 + global_j * global_k];
        
            tmp = rPtr[0];
            turboFFT_ZMUL(rPtr[0], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[1].y + rPtr[1].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[1].y + rPtr[1].x);
        turboFFT_ZMUL(tmp, rPtr[1],r[(64 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[1], r[(64 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[1], r[(64 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[1];
            turboFFT_ZMUL(rPtr[1], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[2].y + rPtr[2].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[2].y + rPtr[2].x);
        turboFFT_ZMUL(tmp, rPtr[2],r[(128 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[2], r[(128 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[2], r[(128 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[2];
            turboFFT_ZMUL(rPtr[2], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[3].y + rPtr[3].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[3].y + rPtr[3].x);
        turboFFT_ZMUL(tmp, rPtr[3],r[(192 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[3], r[(192 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[3], r[(192 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[3];
            turboFFT_ZMUL(rPtr[3], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[8].y + rPtr[8].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[8].y + rPtr[8].x);
        turboFFT_ZMUL(tmp, rPtr[8],r[(256 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[8], r[(256 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[8], r[(256 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[8];
            turboFFT_ZMUL(rPtr[8], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[9].y + rPtr[9].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[9].y + rPtr[9].x);
        turboFFT_ZMUL(tmp, rPtr[9],r[(320 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[9], r[(320 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[9], r[(320 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[9];
            turboFFT_ZMUL(rPtr[9], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[10].y + rPtr[10].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[10].y + rPtr[10].x);
        turboFFT_ZMUL(tmp, rPtr[10],r[(384 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[10], r[(384 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[10], r[(384 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[10];
            turboFFT_ZMUL(rPtr[10], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[11].y + rPtr[11].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[11].y + rPtr[11].x);
        turboFFT_ZMUL(tmp, rPtr[11],r[(448 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[11], r[(448 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[11], r[(448 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[11];
            turboFFT_ZMUL(rPtr[11], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[4].y + rPtr[4].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[4].y + rPtr[4].x);
        turboFFT_ZMUL(tmp, rPtr[4],r[(512 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[4], r[(512 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[4], r[(512 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[4];
            turboFFT_ZMUL(rPtr[4], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[5].y + rPtr[5].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[5].y + rPtr[5].x);
        turboFFT_ZMUL(tmp, rPtr[5],r[(576 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[5], r[(576 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[5], r[(576 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[5];
            turboFFT_ZMUL(rPtr[5], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[6].y + rPtr[6].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[6].y + rPtr[6].x);
        turboFFT_ZMUL(tmp, rPtr[6],r[(640 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[6], r[(640 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[6], r[(640 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[6];
            turboFFT_ZMUL(rPtr[6], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[7].y + rPtr[7].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[7].y + rPtr[7].x);
        turboFFT_ZMUL(tmp, rPtr[7],r[(704 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[7], r[(704 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[7], r[(704 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[7];
            turboFFT_ZMUL(rPtr[7], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[12].y + rPtr[12].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[12].y + rPtr[12].x);
        turboFFT_ZMUL(tmp, rPtr[12],r[(768 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[12], r[(768 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[12], r[(768 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[12];
            turboFFT_ZMUL(rPtr[12], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[13].y + rPtr[13].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[13].y + rPtr[13].x);
        turboFFT_ZMUL(tmp, rPtr[13],r[(832 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[13], r[(832 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[13], r[(832 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[13];
            turboFFT_ZMUL(rPtr[13], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[14].y + rPtr[14].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[14].y + rPtr[14].x);
        turboFFT_ZMUL(tmp, rPtr[14],r[(896 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[14], r[(896 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[14], r[(896 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[14];
            turboFFT_ZMUL(rPtr[14], tmp, angle);
            
        // 1's vector
        // tmp_3.y -=  (rPtr[15].y + rPtr[15].x) * bid_cnt;
        // tmp_1.y -=  (rPtr[15].y + rPtr[15].x);
        turboFFT_ZMUL(tmp, rPtr[15],r[(960 + tx / 8) % 3])
        tmp_1.y -= (tmp.x + tmp.y);
        tmp_3.y -= (tmp.y + tmp.x) * bid_cnt;
        // turboFFT_ZMUL_NACC(tmp_1,  rPtr[15], r[(960 + tx / 8) % 3])
        // turboFFT_ZMUL_NACC(tmp_3,  rPtr[15], r[(960 + tx / 8) % 3])
        
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[15];
            turboFFT_ZMUL(rPtr[15], tmp, angle);
            
            *(gPtr + 0) = rPtr[0];
            rPtr_4[0].x += rPtr[0].x;
            rPtr_4[0].y += rPtr[0].y;
            
            *(gPtr + 32768) = rPtr[1];
            rPtr_4[1].x += rPtr[1].x;
            rPtr_4[1].y += rPtr[1].y;
            
            *(gPtr + 65536) = rPtr[2];
            rPtr_4[2].x += rPtr[2].x;
            rPtr_4[2].y += rPtr[2].y;
            
            *(gPtr + 98304) = rPtr[3];
            rPtr_4[3].x += rPtr[3].x;
            rPtr_4[3].y += rPtr[3].y;
            
            *(gPtr + 131072) = rPtr[8];
            rPtr_4[4].x += rPtr[8].x;
            rPtr_4[4].y += rPtr[8].y;
            
            *(gPtr + 163840) = rPtr[9];
            rPtr_4[5].x += rPtr[9].x;
            rPtr_4[5].y += rPtr[9].y;
            
            *(gPtr + 196608) = rPtr[10];
            rPtr_4[6].x += rPtr[10].x;
            rPtr_4[6].y += rPtr[10].y;
            
            *(gPtr + 229376) = rPtr[11];
            rPtr_4[7].x += rPtr[11].x;
            rPtr_4[7].y += rPtr[11].y;
            
            *(gPtr + 262144) = rPtr[4];
            rPtr_4[8].x += rPtr[4].x;
            rPtr_4[8].y += rPtr[4].y;
            
            *(gPtr + 294912) = rPtr[5];
            rPtr_4[9].x += rPtr[5].x;
            rPtr_4[9].y += rPtr[5].y;
            
            *(gPtr + 327680) = rPtr[6];
            rPtr_4[10].x += rPtr[6].x;
            rPtr_4[10].y += rPtr[6].y;
            
            *(gPtr + 360448) = rPtr[7];
            rPtr_4[11].x += rPtr[7].x;
            rPtr_4[11].y += rPtr[7].y;
            
            *(gPtr + 393216) = rPtr[12];
            rPtr_4[12].x += rPtr[12].x;
            rPtr_4[12].y += rPtr[12].y;
            
            *(gPtr + 425984) = rPtr[13];
            rPtr_4[13].x += rPtr[13].x;
            rPtr_4[13].y += rPtr[13].y;
            
            *(gPtr + 458752) = rPtr[14];
            rPtr_4[14].x += rPtr[14].x;
            rPtr_4[14].y += rPtr[14].y;
            
            *(gPtr + 491520) = rPtr[15];
            rPtr_4[15].x += rPtr[15].x;
            rPtr_4[15].y += rPtr[15].y;
            
        if(bid_cnt==thread_bs)
        
        {
        
        // 1's vector
        // tmp.x = (tx / 8 == 0) ? (rPtr_3[0].y + rPtr_3[0].x) * 1024: 0;
        // tmp.y = (tx / 8 == 0) ? (abs(rPtr_3[0].y) + abs(rPtr_3[0].x)) * 1024: 0;
        tmp = tmp_1;
        tmp_1.y += tmp.x;
        tmp_1.x = (abs(tmp.y) + abs(tmp.x));
        
        // 1's vector
        // tmp.x = (tx / 8 == 0) ? tmp_3.x : 0;
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
        
            tmp_1 = shPtr[(tx % 16) * 2];
            tmp_3 = shPtr[(tx % 16) * 2 + 1];
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 8, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 8, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 8, 32);
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 4, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 4, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 4, 32);
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 2, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 2, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 2, 32);
        
                tmp_1.y += __shfl_xor_sync(0xffffffff, tmp_1.y, 1, 32);
                tmp_1.x += __shfl_xor_sync(0xffffffff, tmp_1.x, 1, 32);
                tmp_3.y += __shfl_xor_sync(0xffffffff, tmp_3.y, 1, 32);
        
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
            // if(tx == 0)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if(tx == 0 && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 1e-3)printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            // if((blockIdx.x % thread_bs + 1) != round(abs(tmp_3.y) / abs(tmp_1.y)) && abs(tmp_1.y) / (1000 + abs(tmp_1.x)) > 0.001 )  printf("1, bid=%d bx=%d, by=%d, tx=%d: checksum=%f, delta=%f, rel=%f, delta_3=%f, delta_3/delta=%f\n",
            //                                         bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x, tmp_3.y, tmp_3.y / tmp_1.y);
            // if(abs(tmp_1.y / tmp_1.x) > 0.001)printf("1, bid=%d bx=%d, by=%d, tx=%d: %f, %f, %f\n", bid, blockIdx.x, blockIdx.y, threadIdx.x, tmp_1.x, tmp_1.y, tmp_1.y / tmp_1.x);
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
                // if(threadIdx.x == 0)printf("bid=%d, upload=%d, bx=%d, tx=%d, k = %d\n", bid, 1, blockIdx.x, threadIdx.x, k);
                // bid = k;
                        
    bx = bid;
    tx = threadIdx.x;
    
            gPtr = inputs;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
        // rPtr[0] = rPtr_3[0];
        rPtr[0] = *(gPtr + 0);
        
        // rPtr[1] = rPtr_3[1];
        rPtr[1] = *(gPtr + 32768);
        
        // rPtr[2] = rPtr_3[2];
        rPtr[2] = *(gPtr + 65536);
        
        // rPtr[3] = rPtr_3[3];
        rPtr[3] = *(gPtr + 98304);
        
        // rPtr[4] = rPtr_3[4];
        rPtr[4] = *(gPtr + 131072);
        
        // rPtr[5] = rPtr_3[5];
        rPtr[5] = *(gPtr + 163840);
        
        // rPtr[6] = rPtr_3[6];
        rPtr[6] = *(gPtr + 196608);
        
        // rPtr[7] = rPtr_3[7];
        rPtr[7] = *(gPtr + 229376);
        
        // rPtr[8] = rPtr_3[8];
        rPtr[8] = *(gPtr + 262144);
        
        // rPtr[9] = rPtr_3[9];
        rPtr[9] = *(gPtr + 294912);
        
        // rPtr[10] = rPtr_3[10];
        rPtr[10] = *(gPtr + 327680);
        
        // rPtr[11] = rPtr_3[11];
        rPtr[11] = *(gPtr + 360448);
        
        // rPtr[12] = rPtr_3[12];
        rPtr[12] = *(gPtr + 393216);
        
        // rPtr[13] = rPtr_3[13];
        rPtr[13] = *(gPtr + 425984);
        
        // rPtr[14] = rPtr_3[14];
        rPtr[14] = *(gPtr + 458752);
        
        // rPtr[15] = rPtr_3[15];
        rPtr[15] = *(gPtr + 491520);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    j = tx / 8;
    
    offset += ((tx / 8) % 4) * 128;
    
    offset += ((tx / 32) % 16) * 512;
    
    __syncthreads();
    
    delta_angle = twiddle[1023 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 8] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 16] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 24] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 32] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 40] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 48] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 56] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 64] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 72] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 80] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 88] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 96] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 104] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 112] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 120] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
        angle.x = 0.9238795325112867;
        angle.y = -0.3826834323650898;
        turboFFT_ZMUL(rPtr[9], tmp, angle);
        
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[10], tmp, angle);
        
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
        angle.x = 0.38268343236508984;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[11], tmp, angle);
        
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = -0.3826834323650897;
        angle.y = -0.9238795325112867;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[14], tmp, angle);
        
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.9238795325112867;
        angle.y = -0.3826834323650899;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
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
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[7], tmp, angle);
        
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
        angle.x = 0.7071067811865476;
        angle.y = -0.7071067811865475;
        turboFFT_ZMUL(rPtr[13], tmp, angle);
        
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
        angle.x = -0.7071067811865475;
        angle.y = -0.7071067811865476;
        turboFFT_ZMUL(rPtr[15], tmp, angle);
        
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    rPtr[11].y = -tmp.x;
    rPtr[11].x = tmp.y;
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[13];
    turboFFT_ZADD(rPtr[13], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
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
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[12];
    turboFFT_ZADD(rPtr[12], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[14];
    turboFFT_ZADD(rPtr[14], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    j = 0;
    offset  = 0;
    
    offset += ((tx / 1) % 8) * 1;
    
    offset += ((tx / 8) % 16) * 8;
    
    j = tx / 128;
    
    offset += ((tx / 128) % 4) * 2048;
    
    __syncthreads();
    
    delta_angle = twiddle[63 + j];
    angle.x = 1;
    angle.y = 0;
    
    shPtr[offset + 0] = rPtr[0];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[8];
    turboFFT_ZMUL(rPtr[8], tmp, angle);
    
    shPtr[offset + 128] = rPtr[8];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[4];
    turboFFT_ZMUL(rPtr[4], tmp, angle);
    
    shPtr[offset + 256] = rPtr[4];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[12];
    turboFFT_ZMUL(rPtr[12], tmp, angle);
    
    shPtr[offset + 384] = rPtr[12];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[2];
    turboFFT_ZMUL(rPtr[2], tmp, angle);
    
    shPtr[offset + 512] = rPtr[2];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[10];
    turboFFT_ZMUL(rPtr[10], tmp, angle);
    
    shPtr[offset + 640] = rPtr[10];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[6];
    turboFFT_ZMUL(rPtr[6], tmp, angle);
    
    shPtr[offset + 768] = rPtr[6];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[14];
    turboFFT_ZMUL(rPtr[14], tmp, angle);
    
    shPtr[offset + 896] = rPtr[14];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[1];
    turboFFT_ZMUL(rPtr[1], tmp, angle);
    
    shPtr[offset + 1024] = rPtr[1];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[9];
    turboFFT_ZMUL(rPtr[9], tmp, angle);
    
    shPtr[offset + 1152] = rPtr[9];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[5];
    turboFFT_ZMUL(rPtr[5], tmp, angle);
    
    shPtr[offset + 1280] = rPtr[5];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[13];
    turboFFT_ZMUL(rPtr[13], tmp, angle);
    
    shPtr[offset + 1408] = rPtr[13];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[3];
    turboFFT_ZMUL(rPtr[3], tmp, angle);
    
    shPtr[offset + 1536] = rPtr[3];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[11];
    turboFFT_ZMUL(rPtr[11], tmp, angle);
    
    shPtr[offset + 1664] = rPtr[11];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[7];
    turboFFT_ZMUL(rPtr[7], tmp, angle);
    
    shPtr[offset + 1792] = rPtr[7];
    
    tmp = angle;
    turboFFT_ZMUL(angle, tmp, delta_angle);
    tmp = rPtr[15];
    turboFFT_ZMUL(rPtr[15], tmp, angle);
    
    shPtr[offset + 1920] = rPtr[15];
    
    offset = 0;
    offset += tx;
    
    __syncthreads();
    
    rPtr[0] = shPtr[offset + 0];
    
    rPtr[1] = shPtr[offset + 512];
    
    rPtr[2] = shPtr[offset + 1024];
    
    rPtr[3] = shPtr[offset + 1536];
    
    rPtr[4] = shPtr[offset + 2048];
    
    rPtr[5] = shPtr[offset + 2560];
    
    rPtr[6] = shPtr[offset + 3072];
    
    rPtr[7] = shPtr[offset + 3584];
    
    rPtr[8] = shPtr[offset + 4096];
    
    rPtr[9] = shPtr[offset + 4608];
    
    rPtr[10] = shPtr[offset + 5120];
    
    rPtr[11] = shPtr[offset + 5632];
    
    rPtr[12] = shPtr[offset + 6144];
    
    rPtr[13] = shPtr[offset + 6656];
    
    rPtr[14] = shPtr[offset + 7168];
    
    rPtr[15] = shPtr[offset + 7680];
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[8]);
    turboFFT_ZSUB(rPtr[8], tmp, rPtr[8]);
    tmp = rPtr[8];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[9]);
    turboFFT_ZSUB(rPtr[9], tmp, rPtr[9]);
    tmp = rPtr[9];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[10]);
    turboFFT_ZSUB(rPtr[10], tmp, rPtr[10]);
    tmp = rPtr[10];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[11]);
    turboFFT_ZSUB(rPtr[11], tmp, rPtr[11]);
    tmp = rPtr[11];
    
    tmp = rPtr[4];
    turboFFT_ZADD(rPtr[4], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    rPtr[12].y = -tmp.x;
    rPtr[12].x = tmp.y;
    
    tmp = rPtr[5];
    turboFFT_ZADD(rPtr[5], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    rPtr[13].y = -tmp.x;
    rPtr[13].x = tmp.y;
    
    tmp = rPtr[6];
    turboFFT_ZADD(rPtr[6], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    rPtr[14].y = -tmp.x;
    rPtr[14].x = tmp.y;
    
    tmp = rPtr[7];
    turboFFT_ZADD(rPtr[7], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
    
    rPtr[15].y = -tmp.x;
    rPtr[15].x = tmp.y;
    
    tmp = rPtr[0];
    turboFFT_ZADD(rPtr[0], tmp, rPtr[4]);
    turboFFT_ZSUB(rPtr[4], tmp, rPtr[4]);
    tmp = rPtr[4];
    
    tmp = rPtr[1];
    turboFFT_ZADD(rPtr[1], tmp, rPtr[5]);
    turboFFT_ZSUB(rPtr[5], tmp, rPtr[5]);
    tmp = rPtr[5];
    
    tmp = rPtr[2];
    turboFFT_ZADD(rPtr[2], tmp, rPtr[6]);
    turboFFT_ZSUB(rPtr[6], tmp, rPtr[6]);
    tmp = rPtr[6];
    
    tmp = rPtr[3];
    turboFFT_ZADD(rPtr[3], tmp, rPtr[7]);
    turboFFT_ZSUB(rPtr[7], tmp, rPtr[7]);
    tmp = rPtr[7];
    
    tmp = rPtr[8];
    turboFFT_ZADD(rPtr[8], tmp, rPtr[12]);
    turboFFT_ZSUB(rPtr[12], tmp, rPtr[12]);
    tmp = rPtr[12];
    
    tmp = rPtr[9];
    turboFFT_ZADD(rPtr[9], tmp, rPtr[13]);
    turboFFT_ZSUB(rPtr[13], tmp, rPtr[13]);
    tmp = rPtr[13];
    
    tmp = rPtr[10];
    turboFFT_ZADD(rPtr[10], tmp, rPtr[14]);
    turboFFT_ZSUB(rPtr[14], tmp, rPtr[14]);
    tmp = rPtr[14];
    
    tmp = rPtr[11];
    turboFFT_ZADD(rPtr[11], tmp, rPtr[15]);
    turboFFT_ZSUB(rPtr[15], tmp, rPtr[15]);
    tmp = rPtr[15];
            
    bx = bid;
    tx = threadIdx.x;
    gPtr = outputs;
    global_j = 0;
    global_k = 0;
    
    global_j += (bx % 64) * 8 * 1;
    
    global_j += (tx % 8) * 1;
    
    gPtr += (bx % 64) * 8 * 1;
    bx = bx / 64;
    
    gPtr += tx % 8 * 1;
    
    gPtr += tx / 8 * 512;
    
    gPtr += (bx % 1) * 1024 * 512;
    bx = bx / 1;
    
    gPtr += (bx % 1024) * 1 * 524288;
    bx = bx / 1024;
    
    gPtr += (bx % BS * 536870912);
    
    global_k += tx / 8;
    
        delta_angle = twiddle[524287 + global_j * (64)];
        angle = twiddle[524287 + global_j * global_k];
        
            tmp = rPtr[0];
            turboFFT_ZMUL(rPtr[0], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[0], rPtr[0], rPtr_4[0]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[1];
            turboFFT_ZMUL(rPtr[1], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[1], rPtr[1], rPtr_4[1]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[2];
            turboFFT_ZMUL(rPtr[2], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[2], rPtr[2], rPtr_4[2]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[3];
            turboFFT_ZMUL(rPtr[3], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[3], rPtr[3], rPtr_4[3]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[8];
            turboFFT_ZMUL(rPtr[8], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[8], rPtr[8], rPtr_4[4]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[9];
            turboFFT_ZMUL(rPtr[9], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[9], rPtr[9], rPtr_4[5]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[10];
            turboFFT_ZMUL(rPtr[10], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[10], rPtr[10], rPtr_4[6]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[11];
            turboFFT_ZMUL(rPtr[11], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[11], rPtr[11], rPtr_4[7]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[4];
            turboFFT_ZMUL(rPtr[4], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[4], rPtr[4], rPtr_4[8]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[5];
            turboFFT_ZMUL(rPtr[5], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[5], rPtr[5], rPtr_4[9]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[6];
            turboFFT_ZMUL(rPtr[6], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[6], rPtr[6], rPtr_4[10]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[7];
            turboFFT_ZMUL(rPtr[7], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[7], rPtr[7], rPtr_4[11]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[12];
            turboFFT_ZMUL(rPtr[12], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[12], rPtr[12], rPtr_4[12]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[13];
            turboFFT_ZMUL(rPtr[13], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[13], rPtr[13], rPtr_4[13]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[14];
            turboFFT_ZMUL(rPtr[14], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[14], rPtr[14], rPtr_4[14]);
            
        tmp = angle;
        turboFFT_ZMUL(angle, tmp, delta_angle);
        
            tmp = rPtr[15];
            turboFFT_ZMUL(rPtr[15], tmp, angle);
            
            // turboFFT_ZSUB(rPtr[15], rPtr[15], rPtr_4[15]);
            
            // rPtr_3[0] = *(gPtr + 0);
            // turboFFT_ZADD(rPtr_3[0], rPtr_3[0], rPtr[0] );
            // *(gPtr + 0) = rPtr_3[0];
            *(gPtr + 0) = rPtr[0];
        
            // rPtr_3[1] = *(gPtr + 32768);
            // turboFFT_ZADD(rPtr_3[1], rPtr_3[1], rPtr[1] );
            // *(gPtr + 32768) = rPtr_3[1];
            *(gPtr + 32768) = rPtr[1];
        
            // rPtr_3[2] = *(gPtr + 65536);
            // turboFFT_ZADD(rPtr_3[2], rPtr_3[2], rPtr[2] );
            // *(gPtr + 65536) = rPtr_3[2];
            *(gPtr + 65536) = rPtr[2];
        
            // rPtr_3[3] = *(gPtr + 98304);
            // turboFFT_ZADD(rPtr_3[3], rPtr_3[3], rPtr[3] );
            // *(gPtr + 98304) = rPtr_3[3];
            *(gPtr + 98304) = rPtr[3];
        
            // rPtr_3[4] = *(gPtr + 131072);
            // turboFFT_ZADD(rPtr_3[4], rPtr_3[4], rPtr[8] );
            // *(gPtr + 131072) = rPtr_3[4];
            *(gPtr + 131072) = rPtr[8];
        
            // rPtr_3[5] = *(gPtr + 163840);
            // turboFFT_ZADD(rPtr_3[5], rPtr_3[5], rPtr[9] );
            // *(gPtr + 163840) = rPtr_3[5];
            *(gPtr + 163840) = rPtr[9];
        
            // rPtr_3[6] = *(gPtr + 196608);
            // turboFFT_ZADD(rPtr_3[6], rPtr_3[6], rPtr[10] );
            // *(gPtr + 196608) = rPtr_3[6];
            *(gPtr + 196608) = rPtr[10];
        
            // rPtr_3[7] = *(gPtr + 229376);
            // turboFFT_ZADD(rPtr_3[7], rPtr_3[7], rPtr[11] );
            // *(gPtr + 229376) = rPtr_3[7];
            *(gPtr + 229376) = rPtr[11];
        
            // rPtr_3[8] = *(gPtr + 262144);
            // turboFFT_ZADD(rPtr_3[8], rPtr_3[8], rPtr[4] );
            // *(gPtr + 262144) = rPtr_3[8];
            *(gPtr + 262144) = rPtr[4];
        
            // rPtr_3[9] = *(gPtr + 294912);
            // turboFFT_ZADD(rPtr_3[9], rPtr_3[9], rPtr[5] );
            // *(gPtr + 294912) = rPtr_3[9];
            *(gPtr + 294912) = rPtr[5];
        
            // rPtr_3[10] = *(gPtr + 327680);
            // turboFFT_ZADD(rPtr_3[10], rPtr_3[10], rPtr[6] );
            // *(gPtr + 327680) = rPtr_3[10];
            *(gPtr + 327680) = rPtr[6];
        
            // rPtr_3[11] = *(gPtr + 360448);
            // turboFFT_ZADD(rPtr_3[11], rPtr_3[11], rPtr[7] );
            // *(gPtr + 360448) = rPtr_3[11];
            *(gPtr + 360448) = rPtr[7];
        
            // rPtr_3[12] = *(gPtr + 393216);
            // turboFFT_ZADD(rPtr_3[12], rPtr_3[12], rPtr[12] );
            // *(gPtr + 393216) = rPtr_3[12];
            *(gPtr + 393216) = rPtr[12];
        
            // rPtr_3[13] = *(gPtr + 425984);
            // turboFFT_ZADD(rPtr_3[13], rPtr_3[13], rPtr[13] );
            // *(gPtr + 425984) = rPtr_3[13];
            *(gPtr + 425984) = rPtr[13];
        
            // rPtr_3[14] = *(gPtr + 458752);
            // turboFFT_ZADD(rPtr_3[14], rPtr_3[14], rPtr[14] );
            // *(gPtr + 458752) = rPtr_3[14];
            *(gPtr + 458752) = rPtr[14];
        
            // rPtr_3[15] = *(gPtr + 491520);
            // turboFFT_ZADD(rPtr_3[15], rPtr_3[15], rPtr[15] );
            // *(gPtr + 491520) = rPtr_3[15];
            *(gPtr + 491520) = rPtr[15];
        }}