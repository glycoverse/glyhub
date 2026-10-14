#!/usr/bin/env python3
"""Verify GPST000578 numeric worksheet values independently of readxl/xlrd.
Usage: python verify_source_biff.py [source.xls] [fixture.json] [matrix-specs.json]
Uses only Python's standard library; supports this checksum-pinned, regular-stream BIFF8 XLS.
Never modifies the source. OLE mini-stream workbooks are deliberately unsupported.
"""
import hashlib,json,pathlib,struct,sys
D=pathlib.Path(__file__).resolve().parent

def ole_workbook(path):
 data=path.read_bytes();assert data[:8]==bytes.fromhex('d0cf11e0a1b11ae1'),'Not an OLE compound document'
 sector_size=1<<struct.unpack_from('<H',data,30)[0]
 u32=lambda b,o:struct.unpack_from('<I',b,o)[0]
 sector=lambda n:data[(n+1)*sector_size:(n+2)*sector_size]
 difat=[x for x in struct.unpack_from('<109I',data,76) if x<0xfffffffa]
 next_id=u32(data,68)
 for _ in range(u32(data,72)):
  part=sector(next_id); vals=struct.unpack('<'+'I'*(sector_size//4),part)
  difat.extend(x for x in vals[:-1] if x<0xfffffffa);next_id=vals[-1]
 fat=[]
 for n in difat[:u32(data,44)]:fat.extend(struct.unpack('<'+'I'*(sector_size//4),sector(n)))
 def chain(start):
  seen=set();chunks=[];n=start
  while n<0xfffffffa:
   assert n not in seen,'Cyclic FAT chain';seen.add(n);chunks.append(sector(n));n=fat[n]
  return b''.join(chunks)
 directory=chain(u32(data,48))
 for off in range(0,len(directory),128):
  entry=directory[off:off+128];ln=struct.unpack_from('<H',entry,64)[0]
  name=entry[:max(0,ln-2)].decode('utf-16le') if ln else ''
  if name in ('Workbook','Book'):
   size=struct.unpack_from('<Q',entry,120)[0]
   assert size>=u32(data,56),'Mini-stream workbook unsupported'
   return chain(u32(entry,116))[:size]
 raise AssertionError('Workbook stream absent')

def rk(raw):
 v=struct.unpack('<i',raw)[0]
 num=(v>>2) if v&2 else struct.unpack('<d',b'\0'*4+struct.pack('<I',struct.unpack('<I',raw)[0]&0xfffffffc))[0]
 return num/100.0 if v&1 else num

def bound_sheets(data):
 pos=0;out={}
 while pos+4<len(data):
  rec,n=struct.unpack_from('<HH',data,pos);b=data[pos+4:pos+4+n]
  if rec==0x85:
   off=struct.unpack_from('<I',b)[0];ln=b[6];wide=b[7]&1
   name=b[8:8+ln*(2 if wide else 1)].decode('utf-16le' if wide else 'latin1');out[name]=off
  pos+=n+4
  if rec==0xa:break
 return out

def numeric_records(data,start):
 pos=start;stack=[];records=[]
 while pos+4<len(data):
  rec,n=struct.unpack_from('<HH',data,pos);b=data[pos+4:pos+4+n]
  if rec==0x809:stack.append(struct.unpack_from('<H',b,2)[0])
  values=[]
  if rec in (0x203,0x27e,0x6) and len(b)>=10:
   row,col=struct.unpack_from('<HH',b)
   if rec==0x27e:value=rk(b[6:10])
   elif rec==0x6 and b[12:14]==b'\xff\xff':value=None
   else:value=struct.unpack_from('<d',b,6)[0]
   if value is not None:values=[(row,col,value)]
  elif rec==0xbd:
   row,startcol=struct.unpack_from('<HH',b);endcol=struct.unpack_from('<H',b,len(b)-2)[0]
   values=[(row,c,rk(b[6+6*(c-startcol):10+6*(c-startcol)])) for c in range(startcol,endcol+1)]
  for row,col,value in values:
   records.append({'row':row+1,'column':col+1,'value':value,'substream_type':hex(stack[-1]),'depth':len(stack),'record_type':hex(rec),'workbook_stream_offset':pos})
  if rec==0xa:
   stack.pop()
   if not stack:break
  pos+=n+4
 return records

def main():
 source=pathlib.Path(sys.argv[1]) if len(sys.argv)>1 else D/'578_41467_2026_73091_MOESM4_ESM.xls'
 fixture=pathlib.Path(sys.argv[2]) if len(sys.argv)>2 else D/'readxl_chart_regression_fixture.json'
 specs=pathlib.Path(sys.argv[3]) if len(sys.argv)>3 else D/'matrix-specs.json'
 f=json.loads(fixture.read_text());sha=hashlib.sha256(source.read_bytes()).hexdigest();assert sha==f['source_sha256'],'Source checksum mismatch'
 data=ole_workbook(source);sheets=bound_sheets(data);cache={name:numeric_records(data,offset) for name,offset in sheets.items()}
 for cell in f['cells']:
  records=cache[f['sheet']];worksheet=[r for r in records if r['depth']==1 and r['substream_type']=='0x10' and r['row']==cell['row'] and r['column']==cell['column']]
  assert len(worksheet)==1 and worksheet[0]['value']==cell['worksheet_value'],cell
  chart=[r for r in records if r['depth']>1 and r['substream_type']=='0x20' and r['row']==cell['row'] and r['column']==cell['column']]
  assert any(r['value']==cell['readxl_chart_cache_value'] for r in chart),cell
  assert cell['worksheet_value']!=cell['readxl_chart_cache_value']
 count=0
 if specs.exists():
  for s in json.loads(specs.read_text()):
   numeric={(r['row'],r['column']):r['value'] for r in cache[s['sheet']] if r['depth']==1 and r['substream_type']=='0x10'}
   for i,row in enumerate(s['row_indices']):
    for j,col in enumerate(s['column_indices']):
     assert numeric[row,col]==s['raw_matrix'][i][j],(s['name'],row,col)
     count+=1
 print(json.dumps({'status':'PASS','source_sha256':sha,'regression_cells':len(f['cells']),'selected_source_cells_verified':count,'numeric_reader':'standard-library OLE/BIFF worksheet-substream parser','source_modified':False},indent=2))
if __name__=='__main__':main()
