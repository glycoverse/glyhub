"""Manual image transcription of SI3/4 most-probable assignments. The fluorescent
AA tag is not a glycan residue. Unknown positions and bracket placement remain
uncertain; source proposed assignments are not upgraded to confirmed topology.
"""
import json,re
from pathlib import Path
out=Path(__file__).parent

def n(m,*ch,edge='?1-?'):return {'m':m,'ch':list(ch),'edge':edge}
def flat(t):return sum([flat(c) for c in t['ch']],[])+[t]
def st(t,root=True):
 c=t['ch'];s=st(c[0],False)+''.join('['+st(x,False)+']' for x in c[1:]) if c else ''
 return s+t['m']+('(b1-' if root else '('+t['edge']+')')
def nc(f=False,a=0):
 top=n('Man',edge='a1-6');bot=n('Man',edge='a1-3');mid=n('Man',top,bot,edge='b1-4');root=n('GlcNAc',n('GlcNAc',mid,edge='b1-4'),*([n('Fuc',edge='a1-6')] if f else []))
 if a:top['ch']=[n('GlcNAc',edge='b1-2')]
 if a>=2:bot['ch']=[n('GlcNAc',edge='b1-2')]
 if a>=3:bot['ch'].insert(0,n('GlcNAc',edge='?1-?'))
 return root
def center(t):return t['ch'][0]['ch'][0]
def floatseq(t,parts,subs=[]):
 nodes=sum([flat(p) for p,tar in parts],[])+flat(t);ix={id(v):i+1 for i,v in enumerate(nodes)}
 # Parent sets refer to all diagram-bracket-covered nodes where no exact site is stated.
 return ''.join('{'+s+'}' for s in subs)+''.join('{'+st(p,False)+'|'+','.join(str(ix[id(q)]) for q in tar if p['edge'].split('-')[1]=='?' or all(c['edge'].split('-')[1]!=p['edge'].split('-')[1] for c in q['ch']))+'}' for p,tar in parts)+st(t)
def arms(t):return sum([flat(v) for v in center(t)['ch']],[])
def put(dic,k,t,parts=[],subs=[]):dic[k]=floatseq(t,parts,subs)
def antenna(t,m='GlcNAc',pc=False,edge='b1-2',fuc=False):
 p=n(m+('?PC' if pc else ''),*([n('Fuc',edge='a1-3')] if fuc else []),edge=edge);return (p,arms(t))
N={}
x=nc();center(x)['ch']=center(x)['ch'][:1];put(N,1,x)
x=nc(True);center(x)['ch']=center(x)['ch'][:1];put(N,2,x)
put(N,3,nc());put(N,4,nc(True))
x=nc();center(x)['ch'][0]['ch']=[n('Man',edge='a1-6')];put(N,5,x)
for k,f in [(6,False),(8,True)]:x=nc(f);center(x)['ch'][1]['m']='Man?PC';put(N,k,x)
for k,f in [(7,False),(10,True)]:x=nc(f);put(N,k,x,[antenna(x)])
x=nc();center(x)['ch'][0]['ch']=[n('Man',edge='a1-6'),n('Man',edge='a1-3')];put(N,9,x)
x=nc();center(x)['ch']=center(x)['ch'][1:];center(x)['ch'][0]['ch']=[n('GlcNAc?PC',n('Fuc',edge='a1-3'),edge='b1-2')];put(N,11,x)
x=nc(a=0);center(x)['ch'][1]['ch']=[n('GlcNAc',edge='b1-2')];put(N,12,x,subs=['?PC'])
put(N,13,nc(a=2))
x=nc();center(x)['ch'][0]['ch']=[n('Man',edge='a1-6'),n('Man',edge='a1-3')];center(x)['ch'][1]['ch']=[n('Man',edge='a1-2')];put(N,14,x)
x=nc(True);put(N,15,x,[antenna(x,fuc=True)])
x=nc(True);center(x)['ch'][1]['m']='Man?PC';put(N,16,x,[antenna(x)])
put(N,17,nc(True,2))
x=nc(a=2);center(x)['ch'][1]['m']='Man?PC';put(N,18,x)
for k,pc in [(19,False),(25,True)]:
 x=nc();p=n('GlcNAc'+('?PC' if pc else ''),n('GalNAc',n('GlcA',edge='b1-?'),edge='b1-4'),edge='b1-2');put(N,k,x,[(p,arms(x))])
put(N,20,nc(a=3))
x=nc();center(x)['ch'][0]['ch']=[n('Man',n('Man',edge='a1-2'),edge='a1-6'),n('Man',edge='a1-3')];center(x)['ch'][1]['ch']=[n('Man',edge='a1-2')];put(N,21,x)
x=nc(True);center(x)['ch'][1]['m']='Man?PC';put(N,22,x,[antenna(x,fuc=True)])
x=nc(True);center(x)['ch'][1]['ch']=[n('GlcNAc',edge='b1-4'),n('GlcNAc',edge='b1-2')];put(N,23,x,[(n('Fuc',edge='a1-3'),arms(x))])
x=nc(True,2);center(x)['ch'][1]['m']='Man?PC';put(N,24,x)
put(N,26,nc(True,3))
x=nc(a=3);center(x)['ch'][1]['m']='Man?PC';put(N,27,x)
for k,count in [(28,8),(35,9),(40,10)]:
 x=nc();center(x)['ch'][0]['ch']=[n('Man',n('Man',edge='a1-2'),edge='a1-6'),n('Man',n('Man',edge='a1-2'),edge='a1-3')];center(x)['ch'][1]['ch']=[n('Man',edge='a1-2')]
 if count>=9:center(x)['ch'][1]['ch'][0]['ch']=[n('Man',edge='a1-2')]
 if count==10:center(x)['ch'][1]['ch'][0]['ch'][0]['ch']=[n('Glc',edge='a1-3')]
 put(N,k,x)
for k,f in [(29,False),(34,True)]:x=nc(f,3);put(N,k,x,[antenna(x,edge='b1-?')])
# GP30 image begins in previous row; handled separately after anchor review.
x=nc(True,2);center(x)['ch'][0]['ch'][0]['m']='GlcNAc?PC';center(x)['ch'][1]['ch'][0]['ch']=[n('Fuc',edge='a1-3')];put(N,30,x)
x=nc(True,2)
for a in center(x)['ch']:a['ch'][0]['m']='GlcNAc?PC'
put(N,31,x)
x=nc(True,3);center(x)['ch'][1]['ch'][0]['edge']='b1-4';put(N,32,x,[(n('Fuc',edge='a1-3'),arms(x))])
x=nc(True,3);center(x)['ch'][1]['m']='Man?PC';put(N,33,x)
x=nc(True,2);put(N,36,x,[(n('Fuc',edge='a1-3'),arms(x))],['?PC','?PC'])
x=nc(True,3);center(x)['ch'][1]['m']='Man?PC';put(N,37,x,[(n('Fuc',edge='a1-3'),arms(x))])
x=nc(True,3);put(N,38,x,subs=['?PC','?PC'])
x=nc(True,3);put(N,39,x,[antenna(x,edge='b1-?',fuc=True)])
x=nc(True,3);put(N,41,x,[(n('Fuc',edge='a1-3'),arms(x))],['?PC','?PC'])
x=nc(True,3);put(N,42,x,subs=['?PC']*3)
x=nc(True,3);put(N,43,x,[antenna(x,pc=True,edge='b1-4'),(n('Fuc',edge='a1-3'),arms(x))])
x=nc(True,3);put(N,44,x,[antenna(x,pc=True,edge='b1-4')],['?PC'])
x=nc(True,3);put(N,45,x,[antenna(x,edge='b1-?'),antenna(x,edge='b1-?'),(n('Fuc',edge='a1-3'),arms(x))])
x=nc(False,3);put(N,46,x,[antenna(x,edge='b1-?') for _ in range(4)])
x=nc(True,3);put(N,47,x,[antenna(x,pc=True,edge='b1-?')],['?PC','?PC'])
# GSL structures consist of the explicitly drawn nematode core and extended chains.
# Chain order below is nonreducing-to-reducing, before Man(b1-4)Glc(b1-).
def gsl(count,end='GlcNAc',gal=False,acid=False,pcs=[],fucs=[]):
 chain=[n('GlcNAc',edge='b1-4') for _ in range(count)];chain[0]['m']=end;chain[-1]['edge']='b1-3'
 for pos in pcs:chain[pos]['m']+='?PC'
 for pos in fucs:chain[pos]['ch'].append(n('Fuc',edge='a1-3'))
 for i in range(1,count):chain[i]['ch'].insert(0,chain[i-1])
 if gal:chain[0]['ch'].insert(0,n('Gal',edge='a1-4'))
 if acid:chain[0]['ch'].insert(0,n('GlcA',edge='b1-?'))
 return n('Glc',n('Man',chain[-1],edge='b1-4')),chain
G={}
def gs(k,count,end='GlcNAc',gal=False,acid=False,pcs=[],fucs=[],floating_pc=0,floating_fuc=0,galf=False):
 x,c=gsl(count,end,gal,acid,pcs,fucs)
 if galf:c[0]['ch'][0]['ch'].append(n('Fuc',edge='a1-3'))
 put(G,k,x,[(n('Fuc',edge='?1-?' if k in [42,44] else 'a1-3'),flat(x)) for _ in range(floating_fuc)],['?PC']*floating_pc)
gs(1,1,pcs=[0]);gs(2,2,'GalNAc',True);gs(3,2,'GalNAc',pcs=[1]);gs(4,2,'GalNAc',True,galf=True);gs(5,2,'GalNAc',True,pcs=[1]);gs(6,2,'GalNAc',acid=True,pcs=[1]);gs(7,3,pcs=[2]);gs(8,2,'GalNAc',True,fucs=[0],galf=True)
gs(9,2,'GalNAc',True,pcs=[1],galf=True);gs(10,3,pcs=[0,2]);gs(11,4,'GalNAc',fucs=[0]);gs(12,4,'GalNAc',pcs=[3]);gs(13,5);gs(14,4,'GalNAc',fucs=[0,1]);gs(15,4,'GalNAc',fucs=[0],floating_pc=1);gs(16,4,'GalNAc',True,pcs=[3])
gs(17,4,'GalNAc',pcs=[1,3]);gs(18,4,'GalNAc',acid=True,pcs=[3]);gs(19,5,'GalNAc',fucs=[0]);gs(20,5,pcs=[0]);gs(21,4,'GalNAc',pcs=[3],fucs=[0,1]);gs(22,4,'GalNAc',pcs=[1,3],fucs=[0]);gs(23,4,'GalNAc',True,pcs=[1,3]);gs(24,5,'GalNAc',fucs=[0,1])
gs(25,4,'GalNAc',acid=True,pcs=[1,3]);gs(26,5,pcs=[4],fucs=[0]);gs(27,5,'GalNAc',pcs=[2,4]);gs(28,5,'GalNAc',acid=True,pcs=[4]);gs(29,6,'GalNAc',fucs=[0]);gs(30,4,acid=True,floating_pc=3);gs(31,5,'GalNAc',pcs=[2,4],fucs=[0]);gs(32,6,'GalNAc',floating_fuc=2)
gs(33,6,'GalNAc',pcs=[3,5]);gs(34,4,'GalNAc',acid=True,pcs=[3]);gs(35,5,'GalNAc',pcs=[2,4],fucs=[0,1]);gs(36,6,'GalNAc',fucs=[0,1,2]);gs(37,5,'GalNAc',acid=True,floating_pc=3);gs(38,7,fucs=[0,1]);gs(39,6,'GalNAc',acid=True,floating_pc=2);gs(40,6,'GalNAc',pcs=[3,5],fucs=[0,1]);gs(41,7,fucs=[0,1,2]);gs(42,6,'GalNAc',acid=True,floating_pc=2,floating_fuc=1);gs(43,6,'GalNAc',acid=True,floating_pc=3);gs(44,7,'GalNAc',acid=True,floating_pc=1,floating_fuc=1);gs(45,8,fucs=[0,1]);gs(46,7,'GalNAc',acid=True,floating_pc=2);gs(47,7,fucs=[0,1,2,3])
assert set(N)==set(range(1,48)) and set(G)==set(range(1,48))
(out/'transcribed-structures.json').write_text(json.dumps([dict(feature_id=f'{typ}-GP{k}',source_row=k+2,structure=v) for typ,d in [('N',N),('GSL',G)] for k,v in sorted(d.items())],indent=2))
