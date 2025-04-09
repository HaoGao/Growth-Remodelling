from odbAccess import *
from abaqusConstants import *
from numpy import *
import numpy as np
import math

#odb data
#pathodb='D:/DBGuan/Growth_Github/Growth-ConstrainMatrix/MI/MI_ND_F_OT_MI_1010/'
#pathfile='D:/DBGuan/Growth_Github/Growth-ConstrainMatrix/MI/MI_ND_F_OT_MI_1010/'
#
file='RBM_updata.odb'
odb=openOdb(file)
assembly=odb.rootAssembly
# instance name
theinst=assembly.instances['PART-1_1']
# node set name
#nodest=theinst.nodeSets['BOCAP']
# element set name
elementst=theinst.elementSets['EALL']
#step name
step1=odb.steps['Preload']
theframe=step1.frames

#frame number; -1 is index of last frame
#extract out displacement values
TempField=theframe[10].fieldOutputs['U'] 
nodest=theinst.nodeSets['BOCAP']
ns2disp=TempField
ns2value=ns2disp.values

#create write out data file

#output7=open('Ndata.txt','w')
output8=open('Udata.txt','w')
#output8.write('%i\n' %(len(ns2value)))
#index=-1
for s in ns2value:
    #index=index+1
    if s.instance!=None:
        if 'PART-1_1' in s.instance.name:
            dispcomp=s.data
            ndx=dispcomp[0]
            ndy=dispcomp[1]
            ndz=dispcomp[2]
            ndID=s.nodeLabel
        
            output8.write('%i,\t %14.10f,\t %14.10f,\t %14.10f\n' %(ndID, ndx,ndy,ndz))

output8.close()
#output7.close()


SDVField1=theframe[-1].fieldOutputs['SDV1'] 
#extract out displacement values
sdv1=SDVField1.getSubset(region=elementst)
sdv2value1=sdv1.values

SDVField2=theframe[-1].fieldOutputs['SDV2'] 
#extract out displacement values
sdv2=SDVField2.getSubset(region=elementst)
sdv2value2=sdv2.values

SDVField3=theframe[-1].fieldOutputs['SDV3'] 
#extract out displacement values
sdv3=SDVField3.getSubset(region=elementst)
sdv2value3=sdv3.values

#create write out data file
output3=open('SDV.txt','w')
#output3.write('%i\n' %(len(sdv2value)))
index=-1
for s in sdv2value1:
    index=index+1
    sdvalue1=s.data
    ndID=s.elementLabel
    sdvalue2=sdv2value2[index].data	
    sdvalue3=sdv2value3[index].data
    output3.write('%i,\t %14.10f,\t %14.10f,\t %14.10f\n' %(ndID, sdvalue1, sdvalue2, sdvalue3))

output3.close()

#SField=theframe[12].fieldOutputs['S']
#sdv5=SField.getSubset(region=elementst)
#sdv5value=sdv5.values
#output5=open(pathfile+'Stress.txt','a')
#index=-1
#stre1=0.0
#stre2=0.0
#stre3=0.0
#stre4=0.0
#stre5=0.0
#stre6=0.0
#for s in sdv5value:
#    index=index+1
#    sdvalue=s.data
#    ndID=s.elementLabel
#    stre1=stre1+sdvalue[0]
#    stre2=stre2+sdvalue[1]
#    stre3=stre3+sdvalue[2]
#    stre4=stre4+sdvalue[3]
#    stre5=stre5+sdvalue[4]
#    stre6=stre6+sdvalue[5]

	
#output5.write('%14.10f,\t %14.10f,\t %14.10f,\t %14.10f,\t %14.10f,\t %14.10f\n' \
#    %(stre1/len(sdv5value),stre2/len(sdv5value),stre3/len(sdv5value), \
#      stre4/len(sdv5value),stre5/len(sdv5value),stre6/len(sdv5value)))

###################################################
# ACTIVE SYSTOLE
step2=odb.steps['Beat']
theframe2=step2.frames

SField=theframe2[-1].fieldOutputs['SDV4'] 
sdv5=SField.getSubset(region=elementst)
sdv5value=sdv5.values
output5=open('Stress.txt','w')
index=-1
for s in sdv5value:
    index=index+1
    sdvalue=s.data
    ndID=s.elementLabel
    output5.write('%i,\t %14.10f\n' %(ndID, sdvalue))

output5.close()


v2=step2.historyRegions

sd4=v2['Node ASSEMBLY.1'].historyOutputs['CVOL']
output4=open('CVOLV.txt','a')
for time, value in sd4.data:
    output4.write('%14.10f, \t%14.10f\n' %(time, value))
output4.close()


sd4=v2['Node ASSEMBLY.1'].historyOutputs['PCAV']
output41=open('PCALV.txt','a')
for time, value in sd4.data:
    output41.write('%14.10f, \t%14.10f\n' %(time, value))
output41.close()
#write out the sdv values for every element


odb.close()



