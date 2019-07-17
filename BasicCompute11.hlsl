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
    for (int j = 0; j < 256; j++)
	{
	    for (int i = 0; i < 9; i++)
	    {
		    BufferOut[DTid.x * 256 + j].f[i] = Buffer0[DTid.x *256 + j].f[i] * Buffer1[DTid.x *256 + j].f[i];
	    }
	}
	
	for (int m = 0; m < 256; m++)
	{
	    for (int n = 0; n < 9; n++)
	    {
		    for (int p = n; p < 9; p++)
			{
		        BufferOut[DTid.x * 256 + m].f[n] *= Buffer0[DTid.x *256 + m].f[p] * Buffer1[DTid.x *256 + m].f[p];
			}
		}
	}
	
	for (int m = 0; m < 256; m++)
	{
	    for (int n = 0; n < 9; n++)
	    {
		    for (int p = n; p < 9; p++)
			{
		        BufferOut[DTid.x * 256 + m].f[n] *= Buffer0[DTid.x *256 + m].f[p] * Buffer1[DTid.x *256 + m].f[p];
			}
		}
	}
}
