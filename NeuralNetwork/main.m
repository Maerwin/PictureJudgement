%% ��ȡ������洢
grades=xlsread('grades.xlsx');
grades=grades(:,2);%��һ��Ϊ�������ڶ���Ϊ���
%% ��ȡͼƬ���洢
TrainDatabasePath = uigetdir('.\datas\allpicture', 'Select training database path' );
img=cell(1,500);
% graImg=cell(1,500);
row=200;
col=150;
graImg=zeros(row,col,500);
parfor i=1:1:500
    index=int2str(i);
    str = strcat(TrainDatabasePath,'\SCUT-FBP-',index,'.jpg');
    img{i}=imread(str);
    img{i}=imresize(img{i},[row,col]);
    graImg(:,:,i)=im2double(rgb2gray(img{i}));
%     subplot(1,2,1),imshow(img{i});
%     title(grades(i),'fontsize',10);
%     subplot(1,2,2),imshow(graImg(:,:,i));
%     title(grades(i),'fontsize',10);
end


m=400;

%���ֳ�ѵ�����Ͳ��Լ�,�������ֹ���Ϊ����
TrainingData=graImg(:,:,1:m);
TrainingResult=round(grades(1:m));

TestData=graImg(:,:,m+1:500);
TestResult=round(grades(m+1:500));


% save 'datas2.mat';
% % ��ȡ����
% clear all;clc;
% load('datas.mat');

%% ����PCA��ѵ�������ݴ������
M=mean(TrainingData,3);


%��ͼ��ɢ������Gt������ɢ������
Gt=zeros(col,col);
for i = 1 : m
    temp = TrainingData(:,:,i)-M;
    Gt =  Gt + temp'*temp;
end
Gt=Gt/m;
d = 25;
[V,~] = eigs(Gt,d);%������ֵ����������
%�Уã��ռ�ͶӰͼ��
V = orth(V); %��V�ı�׼������
ProjectedImages = zeros(row,d);
%�õ��µ�ѵ������
ConvertTrainingData=zeros(row*d,m);
parfor i = 1 : m
    ProjectedImages(:,:,i) = TrainingData(:,:,i)*V;
    ConvertTrainingData(:,i)=reshape(ProjectedImages(:,:,i),[row*d,1])';
end

ConvertTrainingData=premnmx(ConvertTrainingData);

%% ���ݵõ������ݣ��Լ���Ӧ�Ľ�������������紦��

%�����������
class=10;%һ����������
output=zeros(m,class);
for i=1:1:m
    output(i,TrainingResult(i))=1;
end
%����������
net = newff( minmax(ConvertTrainingData) , [d 10] , { 'logsig' 'purelin' } , 'traingdx' ) ;

%����ѵ������
net.trainparam.show = 50 ;
net.trainparam.epochs = 5000 ;
net.trainparam.goal = 0.0001 ;
net.trainParam.lr = 0.2 ;

%��ʼѵ��
%    The matrix format is as follows:
%      X  - RxQ matrix
%      Y  - UxQ matrix.
%    Where:
%      Q  = number of samples
%      R  = number of elements in the network's input
%      U  = number of elements in the network's output
net = train( net, ConvertTrainingData  , output' ) ;

save 'training.mat';

