% load('training1.mat');
row=200;
col=150;
%% �����Ե����ݼ�ת��Ϊ��������ʽ
M=mean(TestData,3);

m=size(TestData,3);

%��ͼ��ɢ������Gt������ɢ������
Gt=zeros(col,col);
for i = 1 : m
    temp = TestData(:,:,i)-M;
    Gt =  Gt + temp'*temp;
end
Gt=Gt/m;
d = 20;
[V,~] = eigs(Gt,d);%������ֵ����������
%�Уã��ռ�ͶӰͼ��
V = orth(V); %��V�ı�׼������
ProjectedImages = zeros(row,d);
%�õ��µ�ѵ������
ConvertTestData=zeros(row*d,m);
parfor i = 1 : m
    ProjectedImages(:,:,i) = TestData(:,:,i)*V;
    ConvertTestData(:,i)=reshape(ProjectedImages(:,:,i),[row*d,1])';
end
ConvertTestData=premnmx(ConvertTestData);
%�����������
class=5;%һ����������
output=zeros(m,class);
for i=1:1:m
    output(i,TestResult(i))=1;
end
%% ��������
Y = sim( net , ConvertTestData );
%ͳ��ʶ����ȷ��

%outputΪ��Ӧ��m*5�����yҲҪΪm*5
Y=Y';%�õ�m*5�����
hitNum = 0 ;
for i=1:1:m
    [~ , Index] = max( Y( i ,  : ) ) ;
    if output(i,Index)==1
        hitNum = hitNum + 1 ;
    end
end
sprintf('ʶ������ %3.3f%%',100 * hitNum / m )


