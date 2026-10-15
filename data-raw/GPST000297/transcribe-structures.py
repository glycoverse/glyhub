"""Review author proposed SNFG topologies in supplementary PDF Tables9/10.
No stereochemistry or bond positions were inferred from biosynthesis.
"""
import json,runpy
from pathlib import Path
def n(m,*ch,edge=None):return {'m':m,'ch':list(ch),'edge':edge or ('?2-?' if m in ('Neu5Ac','Neu5Gc','Kdn') else '?1-?')}
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

R={}
def save(k,t,parts=[],prefix=''):R['N_S47_row'+str(k)]=prefix+(floats(t,parts) if parts else string(t))
def allarms(t):return sum([flat(q) for q in cman(t)['ch']],[])
def ng(a=2,f=True):
 t=core(0,f=f);cman(t)['ch'][0]['ch']=[n('GlcNAc') for _ in range((a+1)//2)];cman(t)['ch'][1]['ch']=[n('GlcNAc') for _ in range(a//2)];return t
x=core(0);cman(x)['ch'][0]['m']='Man?Me';cman(x)['ch'][1]['m']='Man?Me';cman(x)['ch'].append(n('Xyl'));save(1,x)
for k,number in [(2,6),(3,7),(4,8),(6,9)]:
 x=core(0);top,bot=cman(x)['ch'];top['ch']=[n('Man'),n('Man')];bot['ch']=[n('Man')]
 if number>=7:top['ch'][0]['ch']=[n('Man')]
 if number>=8:top['ch'][1]['ch']=[n('Man')]
 if number>=9:bot['ch'][0]['ch']=[n('Man')]
 save(k,x)
x=ng();save(5,x,[(n('HexNAc'),allarms(x)),(n('HexNAc'),allarms(x))])
x=ng(4);save(7,x,[(n('Gal'),allarms(x))])
x=ng(2);cman(x)['ch'][1]['ch'][0]['ch']=[n('Gal',n('Neu5Ac')),n('Fuc')];save(8,x)
x=ng(2);cman(x)['ch'].append(n('GlcNAc'))
for arm in cman(x)['ch'][:2]:arm['ch'][0]['ch']=[n('Gal')]
save(9,x,[(n('GlcNAc',n('Gal')),allarms(x))])
# Row10 diagram contains an additional outlined diamond absent from composition.
# Preserve source evidence separately rather than invent a consistent structure.
# Row11 also conflicts: two drawn Fuc residues versus one in the composition.

x=ng(2)
for a in cman(x)['ch']:a['ch'][0]['ch']=[n('Gal',n('Neu5Ac'))]
save(12,x,[(n('Neu5Ac'),allarms(x)),(n('Fuc'),allarms(x))])
x=ng(2)
for a in cman(x)['ch']:a['ch'][0]['ch']=[n('Gal',n('Neu5Gc'))]
save(13,x,[(n('GlcNAc',n('GalNAc')),allarms(x)),(n('Neu5Gc'),allarms(x))])
x=ng(4);save(14,x,[(n('Gal',n('Neu5Gc')),allarms(x)) for _ in range(3)])
x=ng(4)
for q in allarms(x):
 if q['m']=='GlcNAc':q['ch']=[n('Gal')]
save(15,x,[(n('GlcNAc',n('Gal')),allarms(x)),(n('GlcNAc',n('Gal')),allarms(x)),(n('GlcNAc'),allarms(x))])
x=n('GlcNAc',n('GlcNAc',n('Man',n('Man',n('GlcNAc')))));save(17,x,[(n('Xyl'),flat(x)[:-2])])
x=core(0,f=True);save(18,x,[(n('Xyl'),allarms(x))])
x=core(0,f=True);cman(x)['ch'][0]['ch']=[n('Man')];save(22,x,[(n('Fuc'),allarms(x))])
x=core(0);save(24,x,[(n('GlcNAc',n('Gal',n('Neu5Ac'))),allarms(x))])
x=core(0);save(25,x,[(n('GlcNAc',n('Gal',n('Neu5Ac'))),allarms(x)),(n('Hex'),allarms(x))])
# O-glycan ambiguous parent placement from source brackets.
R['O_S46_row6']='Neu5Ac(?2-?)Gal(?1-?)[HexNAc(?1-?)]GalNAc'
R['O_S46_row7']='Neu5Ac(?2-?)[Fuc(?1-?)Gal(?1-?)[Fuc(?1-?)]HexNAc(?1-?)]GalNAc'
for k in [9,13]:R[f'O_S46_row{k}']='{Fuc(?1-?)|2,3}Gal(?1-?)[Gal(?1-?)]GalNAc'
out=Path(__file__).parent
(out/'transcribed-structures.json').write_text(json.dumps(R,indent=2))
