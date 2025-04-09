%%Initially prepared by Hao Gao, modified by DB
% test on March 2025
clear all; close all; clc;

workingDir = pwd();
dataDir = 'C:\MIGR'; % this is the folder needed by Abaqus subroutine, a windows workstation is needed
abaqusCmd = 'abaqus'; % the command to run abaqus  

%read fibre data
cd(dataDir);
fs_di=load('fibresheet.txt');
fs_dir=fs_di(:,2:7); 
%read node data from update file
node=load('node.txt');
thick=load('Thickness_Element.txt');
%load('SDV_C1');
cd(workingDir);

if exist('CVOLV.txt', 'file')==2
  delete('CVOLV.txt');
end
if exist('PCALV.txt', 'file')==2
  delete('PCALV.txt');
end
Make_InitialFile;

%stateSum=ones(size(fs_dir,1),4); %should be volume fraction and total
%stateSum(:,1)=0.274;stateSum(:,2)=0.7;stateSum(:,3)=0.026; %should be volume fraction and total
cd(dataDir);
tt1=readtable('FGPI_sum_MI.txt', 'HeaderLines', 1);
cd(workingDir);
stateSum=table2array(tt1);

cd(dataDir);
MIelement=load('MIelement.txt');
MarkMI=load('MarkRegionMI.txt');
cd(workingDir);

stateNew=ones(size(fs_dir,1),4); %should be growth amount at this cycle
stateOld=ones(size(fs_dir,1),4); %should be growth amount at this cycle
gv=ones(size(fs_dir,1),4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    cd(dataDir);
    fid6 = fopen('FGPI_sum.txt','w');
    cd(workingDir);
    fprintf(fid6, '%i\n',size(fs_dir,1));
    for i = 1 : size(fs_dir,1)
        fprintf(fid6, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%i\n', ...
            stateSum(i,1),stateSum(i,2),stateSum(i,3),stateSum(i,4),MarkMI(i,1));
    end
    fclose(fid6);
    
    
for cycle=1:12
    %cases={'RBM_updata'  'Coarse_fibresheetDir.inp'};
    ['cycle=' num2str(cycle)]
%     
    if cycle<8
        pressure=8*133.322/1000000;
        mlamdb=100000; mlamdbs=100000; SDV1=[];SDV2=[];
    else
        SDV1=load('SDV_Normal.txt');SDV2=load('Stress_Normal.txt'); % how to generate them
        pressure=23*133.322/1000000;
        mlamdb=mean(SDV1(:,2)); mlamdbs=nanmean(SDV2(:,2)); SDV1=[];SDV2=[];
    end
%     
%%***********************************************************************************************************
%%***********************************************************************************************************

    
	%update input file
	'update input file'
        fidr = fopen('Normal_Update.inp','rt');
        filename='RBM_updata';
        fidw = fopen([filename '.inp'],'wt');   
        
        line=0;
		lineupdate=0;lineupdate2=0;
        while feof(fidr) == 0  %from first line to the last one 
            line=line+1;
            s = fgetl(fidr);  
            if line>=11 && line <= 26020
				lineupdate=lineupdate+1;
                fprintf(fidw,'\t%i,\t%14.10f,\t%14.10f,\t%14.10f\n',node(lineupdate,1),node(lineupdate,2),node(lineupdate,3),node(lineupdate,4));
            elseif  line>=26024 && line<=159065
                lineupdate2=lineupdate2+1;
                fprintf(fidw,'%i,\t%f,\t%f,\t%f,\t%f,\t%f,\t%f\n',lineupdate2,fs_dir(lineupdate2,1),fs_dir(lineupdate2,2),fs_dir(lineupdate2,3), ...
                    fs_dir(lineupdate2,4),fs_dir(lineupdate2,5),fs_dir(lineupdate2,6));
            elseif line==159532
                fprintf(fidw,'RP-LA, 8, 8, %14.10f\n', pressure);
            elseif line==159535
                fprintf(fidw,'RP-CAV, 8, 8, %14.10f\n', pressure);
            elseif line==159609
                fprintf(fidw,'RP-LA, 8, 8, %14.10f\n', pressure);
            else
                fprintf(fidw,'%s\n',s);
            end
            
        end
        
        fclose(fidr);
        fclose(fidw);
        
%%***********************************************************************************************************
%%***********************************************************************************************************
    
    %run abaqus 
    %%% for linux
% 	'run abaqus'
%     abaqus_inputfile=filename;
%     com1='source /opt/intel/bin/compilervars.sh intel64';
%     [status,result] = system(com1,'-echo');
%     %com2='/opt/software/abaqus2021/SIMULIA/Commands/abq2021';
%     command = sprintf('/opt/software/abaqus2021/SIMULIA/Commands/abq2021 job=%s user=newtest_Residual cpus=42 interactive ask=off',abaqus_inputfile);  
%     [status,result] = system(command,'-echo');

    %%%  for windows
    abaqus_inputfile=filename;
    command = sprintf('%s job=%s user=newtest_Residual cpus=32 interactive double=both',abaqusCmd, abaqus_inputfile);  
    [status,result] = system(command,'-echo');
     
   
    copyfile('RBM_updata.inp', [abaqus_inputfile num2str(cycle) '.inp']);
    copyfile('RBM_updata.odb', [abaqus_inputfile num2str(cycle) '.odb']);

%%***********************************************************************************************************
%%***********************************************************************************************************

	%run python code to read node date after computation    
	'run python code to read node date after computation'  
    %system(['/opt/software/abaqus2021/SIMULIA/Commands/abq2021 ' 'script=readNode_outSDV.py']); %Windows system? and output node.txt
    % the above to be updated
    postprocess_cmd = sprintf('%s script=readNode_outSDV.py', abaqusCmd);
    system(postprocess_cmd);

    ComputeFFGFR;
    %ComputeFFGFR_NoResidual;
        
    

       
    
    %save workspace
    save(['cycle_' num2str(cycle)])
    %copy file
    cd(dataDir);
    copyfile('Fr_G.txt', [ 'Fr_G_' num2str(cycle) '.txt']);
    copyfile('Fr_M.txt', [ 'Fr_M_' num2str(cycle) '.txt']);
    copyfile('Fr_C.txt', [ 'Fr_C_' num2str(cycle) '.txt']);
    copyfile('FGPI_G.txt', [ 'FGPI_G_' num2str(cycle) '.txt']);
    copyfile('FGPI_M.txt', [ 'FGPI_M_' num2str(cycle) '.txt']);
    copyfile('FGPI_C.txt', [ 'FGPI_C_' num2str(cycle) '.txt']);
    copyfile('FGPI_sum.txt', [ 'FGPI_sum_' num2str(cycle) '.txt']);
    copyfile('FibreD.txt', [ 'FibreD_' num2str(cycle) '.txt']);
    cd(workingDir);
    
    copyfile('Udata.txt', [ 'Udata_' num2str(cycle) '.txt']);
    copyfile('SDV.txt', [ 'SDV_' num2str(cycle) '.txt']);
    copyfile('Stress.txt', [ 'Stress_' num2str(cycle) '.txt']);
         
end

        
    cycle_num(1,1)=cycle;
    cycle_num(1,2)=pressure;







