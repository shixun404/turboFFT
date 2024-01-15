def main_codegen(data_type):
    main_code = f'''
    #include "include/turbofft_{data_type}.h"

    // #define DataType double2
    #define DataType {data_type}
    '''

    main_code += '''

void test_turbofft( DataType* input_d, DataType* output_d, DataType* output_turbofft,
                    DataType* twiddle_d, std::vector<long long int> param, 
                    long long int bs, int ntest){
    long long int N = (1 << param[0]), threadblock_bs, Ni, WorkerFFTSize;
    long long int logN = param[0];
    long long int shared_size[3], griddims[3], blockdims[3]; 
    DataType* inputs[3] = {input_d, output_d, output_d + N * bs};
    DataType* outputs[3] = {output_d, output_d + N * bs, output_d};
    int kernel_launch_times = param[1];
    float gflops, elapsed_time, mem_bandwidth;
    cudaEvent_t fft_begin, fft_end;
    // printf("adasdas\\n");
    for(int i = 0; i < kernel_launch_times; ++i){
        // threadblock_bs = min((kernel_launch_times < 2 && bs < threadblock_bs) ? bs : param[5 + i], param[5 + i]);
        threadblock_bs = param[5 + i];
        Ni = (1 << param[2 + i]); 
        WorkerFFTSize = param[8 + i]; 
        shared_size[i] = Ni * threadblock_bs * sizeof(DataType);
        griddims[i] = (N * bs) / (Ni * threadblock_bs);
        blockdims[i] = (Ni * threadblock_bs) / WorkerFFTSize;
        // printf("kernel=%d: gridDim=%d, blockDim=%d, share_mem_size=%d\\n", i, griddims[i], blockdims[i], shared_size[i]);
        cudaFuncSetAttribute(turboFFTArr[logN][i], cudaFuncAttributeMaxDynamicSharedMemorySize, shared_size[i]);
    }
    
    cudaEventCreate(&fft_begin);
    cudaEventCreate(&fft_end);

    cudaEventRecord(fft_begin);
    #pragma unroll
    for (int j = 0; j < ntest; ++j){
        #pragma unroll
        for(int i = 0; i < kernel_launch_times; ++i){
            turboFFTArr[logN][i]<<<griddims[i], blockdims[i], shared_size[i]>>>(inputs[i], outputs[i], twiddle_d, bs);
        }
        cudaDeviceSynchronize();
    }
    cudaEventRecord(fft_end);
    cudaEventSynchronize(fft_begin);
    cudaEventSynchronize(fft_end);
    cudaEventElapsedTime(&elapsed_time, fft_begin, fft_end);

    
    elapsed_time = elapsed_time / ntest;
    gflops = 5 * N * log2f(N) * bs / elapsed_time * 1000 / 1000000000.f;
    mem_bandwidth = (float)(N * bs * 8 * 2) / (elapsed_time) * 1000.f / 1000000000.f;
    // printf("turboFFT finished: T=%8.3fms, FLOPS=%8.3fGFLOPS\\n", elapsed_time, gflops);
    printf("turboFFT, %d, %d, %8.3f, %8.3f, %8.3f\\n",  (int)log2f(N),  (int)log2f(bs), elapsed_time, gflops, mem_bandwidth);
    
    checkCudaErrors(cudaMemcpy((void*)output_turbofft, (void*)outputs[kernel_launch_times - 1], N * bs * sizeof(DataType), cudaMemcpyDeviceToHost));
}


int main(int argc, char *argv[]){
    if (argc < 3) {
        std::cerr << "Usage: program_name N bs" << std::endl;
        return 1;
    }
    
    long long logN = std::atol(argv[1]); // Convert first argument to integer
    long long N = 1 << logN; // Convert first argument to integer
    long long bs = std::atol(argv[2]); // Convert second argument to integer
    bool if_profile = 1;
    bool if_verify = 0;
    bool if_bench = 0;
    
    if (argc >= 4) if_profile = std::atol(argv[3]);
    if (argc >= 5) if_verify  = std::atol(argv[4]);
    if (argc >= 6) if_bench = std::atol(argv[5]);
    

    DataType* input, *output_turbofft, *output_cufft;
    DataType* input_d, *output_d, *twiddle_d;
    int ntest = 10;

    std::vector<std::vector<long long int>> params;
    '''
    main_code += f'''
    std::string param_file_path = "../include/param/param_A100_{data_type}.csv";
    '''
    main_code += '''
    params = utils::load_parameters(param_file_path);


    
    if(!if_bench){
        // Verification
        utils::initializeData<DataType>(input, input_d, output_d, output_turbofft, output_cufft, twiddle_d, N, bs + 3);

        if(if_verify){
            test_turbofft(input_d, output_d, output_turbofft, twiddle_d, params[logN], bs, 1);
            profiler::cufft::test_cufft<DataType>(input_d, output_d, output_cufft, N, bs, 1);
            
            utils::compareData<DataType>(output_turbofft, output_cufft, N * bs, 1e-4);
        }

        // Profiling
        if(if_profile){
            // test_turbofft(input_d, output_d, output_turbofft, twiddle_d, params[logN], bs, ntest);        
            
            profiler::cufft::test_cufft<DataType>(input_d, output_d, output_cufft, N, bs, ntest);
            test_turbofft(input_d, output_d, output_turbofft, twiddle_d, params[logN], bs, ntest);        

            
            // test_turbofft(input_d, output_d, output_turbofft, twiddle_d, params[logN], bs, ntest);
        }
    }

    if(if_bench){
        printf("asdadas\\n");
        utils::initializeData<DataType>(input, input_d, output_d, output_turbofft, output_cufft, twiddle_d, 1 << 25, 16 + 3);
        N = 1;
        for(logN = 1; logN <= 25; ++logN){
            N *= 2;
            bs = 1;
            for(int i = 0; i < 29 - logN; i += 1){
                profiler::cufft::test_cufft<DataType>(input_d, output_d, output_cufft, N, bs, ntest);
                test_turbofft(input_d, output_d, output_turbofft, twiddle_d, params[logN], bs, ntest);        
                bs *= 2;
            }
        }

    }
    cudaFree(input_d);
    cudaFree(output_d);
    cudaFree(twiddle_d);
    free(input);
    free(output_cufft);
    free(output_turbofft);
    return 0;
}

// profiler::cufft::test_cufft_ft<DataType>(input_d, output_d, output_cufft, input_d + N * (bs + 2),
//                                          input_d + N * (bs + 1), output_d + N * (bs + 2),   N, bs, ntest);
// profiler::cufft::test_cufft_ft<DataType>(input_d, output_d, output_cufft, input_d + N * (bs + 2),
//                                          input_d + N * (bs + 1), output_d + N * (bs + 2),   N, bs, ntest);

    '''
    return main_code

if __name__ == '__main__':
    main_code = main_codegen('float2')
    file_name = "../../../main.cu"
    with open(file_name, 'w') as f:
        f.write(main_code)