%% ��ȡ������洢
grades=xlsread('grades.xlsx');
grades=grades(:,2);%��һ��Ϊ�������ڶ���Ϊ���
%% ��ȡͼƬ���洢
TrainDatabasePath = uigetdir('.\datas\allpicture', 'Select training database path' );
img=cell(1,500);
graImg=cell(1,500);
for i=1:1:500
    index=int2str(i);
    str = strcat(TrainDatabasePath,'\SCUT-FBP-',index,'.jpg');
    img{i}=imread(str);
    img{i}=imresize(img{i},[800,600]);
    graImg{i}=rgb2gray(img{i});
    subplot(1,2,1),imshow(img{i});
    title(grades(i),'fontsize',10);
    subplot(1,2,2),imshow(graImg{i});
    title(grades(i),'fontsize',10);
end
%% 
