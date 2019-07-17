//--------------------------------------------------------------------------------------
// File: BasicCompute11.hlsl
//
// This file contains the Compute Shader to perform array A + array B
// 
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------

#ifdef USE_STRUCTURED_BUFFERS

struct BufType
{
	matrix<float, 4, 4> f[10];
};

StructuredBuffer<BufType> Buffer0 : register(t0);
StructuredBuffer<BufType> Buffer1 : register(t1);
RWStructuredBuffer<BufType> BufferOut : register(u0);

[numthreads(1, 1, 1)]
void CSMain( uint3 DTid : SV_DispatchThreadID )
{
	for (int i = 0; i < 10; i++)
	{
		BufferOut[DTid.x].f[i] = Buffer0[DTid.x].f[i] * Buffer0[DTid.x].f[i]  * Buffer1[DTid.x].f[i] * Buffer1[DTid.x].f[i];
	}
}

#else // The following code is for raw buffers

ByteAddressBuffer Buffer0 : register(t0);
ByteAddressBuffer Buffer1 : register(t1);
RWByteAddressBuffer BufferOut : register(u0);

[numthreads(1, 1, 1)]
void CSMain( uint3 DTid : SV_DispatchThreadID )
{
#ifdef TEST_DOUBLE
    int i0 = asint( Buffer0.Load( DTid.x*16 ) );
    float f0 = asfloat( Buffer0.Load( DTid.x*16+4 ) );
    double d0 = asdouble( Buffer0.Load( DTid.x*16+8 ), Buffer0.Load( DTid.x*16+12 ) );
    int i1 = asint( Buffer1.Load( DTid.x*16 ) );
    float f1 = asfloat( Buffer1.Load( DTid.x*16+4 ) );
    double d1 = asdouble( Buffer1.Load( DTid.x*16+8 ), Buffer1.Load( DTid.x*16+12 ) );
    
    BufferOut.Store( DTid.x*16, asuint(i0 + i1) );
    BufferOut.Store( DTid.x*16+4, asuint(f0 + f1) );
    
    uint dl, dh;
    asuint( d0 + d1, dl, dh );

    BufferOut.Store( DTid.x*16+8, dl );
    BufferOut.Store( DTid.x*16+12, dh );
#else
    int i0 = Buffer0[DTid.x].i;
    float f0 = Buffer0[DTid.x].f;
    int i1 = Buffer1[DTid.x].i;
    float f1 = Buffer1.[DTid.x].f;

	BufferOut[DTid.x].i = i0 + i1;
	BufferOut[DTid.x].f = f0 + f1;
#endif // TEST_DOUBLE
}

#endif // USE_STRUCTURED_BUFFERS
