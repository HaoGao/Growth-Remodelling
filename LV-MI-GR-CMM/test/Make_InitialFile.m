% clear all; close all; clc;
% 
% %read fibre data
% fs_di=load('fibresheet.txt');
% fs_dir=fs_di(:,2:7); 

cd(dataDir);
fid2 = fopen('Fr_G.txt','w');
cd(workingDir);
fprintf(fid2, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid2, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 1, 1, 0, 0, 0,0,0,0);
end
fclose(fid2);

cd(dataDir);
fid6 = fopen('Fr_M.txt','w');
cd(workingDir);
fprintf(fid6, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid6, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 1, 1, 0, 0, 0,0,0,0);
end
fclose(fid6);

fid7 = fopen('Fr_C.txt','w');
fprintf(fid7, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid7, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 1, 1, 0, 0, 0,0,0,0);
end
fclose(fid7);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(dataDir);
fid3 = fopen('FGPI_G.txt','w');
cd(workingDir)
fprintf(fid3, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid3, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 1, 1, 0, 0, 0,0,0,0);
end
fclose(fid3);

cd(dataDir);    
fid4 = fopen('FGPI_M.txt','w');
cd(workingDir);
fprintf(fid4, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid4, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 1, 1, 0, 0, 0,0,0,0);
end
fclose(fid4);

cd(dataDir);
fid5 = fopen('FGPI_C.txt','w');
cd(workingDir);
fprintf(fid5, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid5, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 1, 1, 0, 0, 0,0,0,0);
end
fclose(fid5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

cd(dataDir);
copyfile('FGPI_sum_MI.txt', 'FGPI_sum.txt');
cd(workingDir);
%    fid6 = fopen('FGPI_sum.txt','w');
%    fprintf(fid6, '%i\n',size(fs_dir,1));
%    for i = 1 : size(fs_dir,1)
%        fprintf(fid6, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
%            0.274,0.7,0.026,1);
%    fclose(fid6);

cd(dataDir);
fid7 = fopen('FibreD.txt','w');
cd(workingDir);
fprintf(fid7, '%i\n',size(fs_dir,1));
for i = 1 : size(fs_dir,1)
    fprintf(fid7, '%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f,\t%14.10f\n', ...
        1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1,0,0);
end
fclose(fid7);
    