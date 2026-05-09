#include "rar.hpp"

RAROptions::RAROptions()
{
  Init();
}


RAROptions::~RAROptions()
{
  // It is important for security reasons, so we do not have the unnecessary
  // password data left in memory.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnontrivial-memcall"
  memset(this,0,sizeof(RAROptions));
#pragma clang diagnostic pop
}


void RAROptions::Init()
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnontrivial-memcall"
  memset(this,0,sizeof(RAROptions));
#pragma clang diagnostic pop
  WinSize=0x2000000;
  Overwrite=OVERWRITE_DEFAULT;
  Method=3;
  MsgStream=MSG_STDOUT;
  ConvertNames=NAMES_ORIGINALCASE;
  xmtime=EXTTIME_MAX;
  FileSizeLess=INT64NDF;
  FileSizeMore=INT64NDF;
  HashType=HASH_CRC32;
#ifdef RAR_SMP
  Threads=GetNumberOfThreads();
#endif
#ifdef USE_QOPEN
  QOpenMode=QOPEN_AUTO;
#endif
}
