"""Manual transcription of author SNFG topology from SI Data3, column B.
Images reviewed row-by-row; unmarked linkages remain unknown. Labels retained.
"""
import json,copy
from pathlib import Path
out=Path(__file__).parent

def n(m,*ch,edge=None):return {'m':m,'ch':list(ch),'edge':edge or ('?2-?' if m=='Neu5Ac' else '?1-?')}
def G(s=None):return n('Gal',*([] if s is None else [n('Neu5Ac',edge=s)]))
def arm(g=False,s=None):return n('GlcNAc',*([G(s)] if g else []))
def core(a=2,g=False,b=False,f=False,s=None):
 arms=[arm(g,s) for _ in range(a)]
 top=n('Man',*arms[:1]);bottom=n('Man',*arms[1:]);center=n('Man',top,bottom,*([n('GlcNAc')] if b else []))
 return n('GlcNAc',n('GlcNAc',center),*([n('Fuc')] if f else []))
def onecore(f=True,b=False):return core(0,False,b,f)
def flat(t):
 return sum([flat(c) for c in t['ch']],[])+[t]
def string(t,root=True):
 ch=t['ch'];v=''
 if ch:v=string(ch[0],False)+''.join('['+string(c,False)+']' for c in ch[1:])
 return v+t['m']+('' if root else '('+t['edge']+')')
def floats(t,parts):
 # Each part has a subtree and evidence-supported candidate parent node objects.
 nodes=sum([flat(p) for p,targets in parts],[])+flat(t)
 ix={id(v):i+1 for i,v in enumerate(nodes)}
 return ''.join('{'+string(p,False)+'|'+','.join(str(ix[id(q)]) for q in targets)+'}' for p,targets in parts)+string(t)
def tips(t,m):return [q for q in flat(t) if q['m']==m and not q['ch']]
def cman(t):return t['ch'][0]['ch'][0]
def add(t,p,parents):return floats(t,[(p,parents)])
R={};notes={}
def save(row,t,parts=[]):R[row]=floats(t,parts) if parts else string(t)
def floating_s(row,a=2,b=False,f=False,count=1,edge='?2-?',g=True):
 t=core(a,g,b,f);save(row,t,[(n('Neu5Ac',edge=edge),tips(t,'Gal')) for _ in range(count)])
# Rows2-22
x=core();save(2,x,[(n('Gal',n('Neu5Ac')),tips(x,'GlcNAc'))])
save(3,core(2,True))
x=core(2,True,s='?2-?');save(4,x,[(n('Fuc'),[q for q in flat(x) if q['m'] not in ['Man'] and q is not x and q is not x['ch'][0]])])
floating_s(5,edge='?2-3');floating_s(6,edge='?2-6')
for r in [7,8]:
 x=core(2,True);save(r,x,[(n('Neu5Ac'),tips(x,'Gal')),(n('Fuc'),[q for q in flat(x) if q['m'] not in ['Man'] and q is not x and q is not x['ch'][0]])])
save(9,core(2,True,s='?2-3'))
x=core(2,True,s='?2-3');tips(x,'Neu5Ac')[0]['edge']='?2-6';save(10,x)
save(11,core(2,True,s='?2-6'))
for r in [12,13]:floating_s(r,3)
for r in range(14,19):floating_s(r,3,count=2)
for r in [19,20]:save(r,core(3,True,s='?2-?'))
for r in [21,22]:
 x=core(3,True,s='?2-?');save(r,x,[(n('Neu5Ac'),[q for q in flat(x) if q['m'] in ['Gal','Neu5Ac','GlcNAc'] and q is not x and q is not x['ch'][0]])])
# Bisected and corefucosylated complex glycans.
save(23,core(2,b=True))
x=core(2,b=True);save(24,x,[(G(),tips(x,'GlcNAc'))])
save(25,core(2,True,b=True));floating_s(26,b=True)
for r,link in [(27,'?2-3'),(28,'?2-6')]:
 x=onecore();save(r,x,[(arm(True,link),tips(x,'Man'))])
save(29,core(f=True))
x=core(f=True);save(30,x,[(G(),tips(x,'GlcNAc'))])
x=core(f=True);save(31,x,[(G('?2-?'),tips(x,'GlcNAc'))])
save(32,core(2,True,f=True));floating_s(33,f=True,edge='?2-6');floating_s(34,f=True,edge='?2-3')
save(35,core(2,True,f=True,s='?2-3'));x=core(2,True,f=True,s='?2-3');tips(x,'Neu5Ac')[0]['edge']='?2-6';save(36,x);save(37,core(2,True,f=True,s='?2-6'))
save(38,core(3,True,f=True));notes[38]='Author label FA3 omits the three Gal residues explicitly shown in the likely-structure diagram; typed composition and structure are missing because the source label and diagram conflict.'
floating_s(39,3,f=True)
for r in [40,41,42]:floating_s(r,3,f=True,count=2)
for r in [43,44]:save(r,core(3,True,f=True,s='?2-?'))
x=core(3,True,f=True);save(45,x,[(n('Neu5Ac'),tips(x,'Gal')),(arm(True,'?2-?'),[q for q in flat(x) if q['m']=='Man' and q is not cman(x)])])
x=onecore(b=True);cman(x)['ch'][1]['ch']=[arm(True,'?2-?')];save(46,x)
save(47,core(b=True,f=True))
for r,parts in [(48,1),(49,2),(50,3),(51,3)]:
 x=core(b=True,f=True);parents=[q for q in flat(x) if q['m']=='GlcNAc' and not q['ch']]
 pp=[(G('?2-?') if parts==3 else G(),parents)]
 if parts==2:pp.append((n('Fuc'),parents+[pp[0][0]]))
 save(r,x,pp)
save(52,core(2,True,b=True,f=True))
for r in [53,54,55]:
 x=core(2,True,b=True,f=True);pp=[(n('Fuc'),[q for q in flat(x) if q['m'] not in ['Man'] and q is not x and q is not x['ch'][0]])]
 if r!=53:pp.append((n('Neu5Ac'),tips(x,'Gal')))
 save(r,x,pp)
for r in [56,57]:floating_s(r,b=True,f=True)
for r in [58,59,60]:save(r,core(2,True,b=True,f=True,s='?2-?'))
for r in [61,62]:floating_s(r,3,b=True,f=True)
for r in [63,64,65]:floating_s(r,3,b=True,f=True,count=2)
# Hybrid, paucimannose, highmannose. Parent placement follows drawn topology.
x=onecore(b=True);cman(x)['ch'][0]['ch']=[n('Man')];cman(x)['ch'][1]['ch']=[arm()];save(66,x)
for r,link in [(67,'?2-3'),(68,'?2-6'),(69,'?2-?'),(75,'?2-3'),(76,'?2-6')]:
 x=onecore(f=r<70);cman(x)['ch'][0]['ch']=[n('Man')]+([n('Man')] if r in [69,75,76] else []);cman(x)['ch'][1]['ch']=[arm(True,link)];save(r,x)
x=n('GlcNAc',n('GlcNAc',n('Man',n('Man'))),n('Fuc'));save(70,x)
save(71,onecore(False));save(72,onecore(True))
for r,num in [(73,4),(74,5),(77,6),(78,6),(79,7),(80,7),(81,8),(82,9),(83,9)]:
 x=onecore(False);center=cman(x);top,bottom=center['ch'];top['ch']=[n('Man')]
 if num>=5:top['ch'].append(n('Man'))
 if num>=6:bottom['ch']=[n('Man')]
 if num>=7:bottom['ch'][0]['ch']=[n('Man')]
 if num>=8:top['ch'][1]['ch']=[n('Man')]
 if num>=9:top['ch'][0]['ch']=[n('Man')]
 if r==83:bottom['ch'][0]['ch'][0]['ch']=[n('Glc')]
 if r in [78,80]:top['ch'][0]['m']='Man?P';notes[r]='Phosphate is attached to the drawn terminal mannose; its position is unspecified.'
 save(r,x)
assert set(R)==set(range(2,84))
labels={v['row']:v['label'] for v in json.load(open(out/'images.json'))}
rec=[dict(row=r,label=labels[r],structure=s,status='source proposed topology; unmarked linkages unknown',note=notes.get(r,'')) for r,s in sorted(R.items())]
(out/'transcribed-structures.json').write_text(json.dumps(rec,indent=2))
